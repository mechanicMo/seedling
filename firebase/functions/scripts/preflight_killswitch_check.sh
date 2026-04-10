#!/bin/bash
# Seedling Kill Switch Preflight Check
# Run this before deploying Cloud Functions to verify kill switch is properly configured
# Usage: bash scripts/preflight_killswitch_check.sh

set -e

PROJECT_ID="seedling-5a9f6"
BILLING_ACCOUNT="01304E-2CCB76-E299B1"
SERVICE_ACCOUNT="seedling-5a9f6@appspot.gserviceaccount.com"
PUBSUB_TOPIC="billing-kill-switch"

echo "🔍 Seedling Kill Switch Preflight Check"
echo "========================================"
echo ""

# Check 1: killSwitch function exists in code
echo "✓ Check 1: killSwitch function in code"
if grep -q "export const killSwitch" src/index.ts; then
    echo "  ✅ PASS: killSwitch function found in src/index.ts"
else
    echo "  ❌ FAIL: killSwitch function NOT found in src/index.ts"
    exit 1
fi

# Check 2: @google-cloud/billing in package.json
echo ""
echo "✓ Check 2: @google-cloud/billing dependency"
if grep -q "@google-cloud/billing" package.json; then
    echo "  ✅ PASS: @google-cloud/billing found in package.json"
else
    echo "  ❌ FAIL: @google-cloud/billing NOT in package.json"
    exit 1
fi

# Check 3: Pub/Sub topic exists
echo ""
echo "✓ Check 3: Pub/Sub topic '$PUBSUB_TOPIC'"
if gcloud pubsub topics list --project="$PROJECT_ID" --filter="name:$PUBSUB_TOPIC" --format="value(name)" 2>/dev/null | grep -q "$PUBSUB_TOPIC"; then
    echo "  ✅ PASS: Topic projects/$PROJECT_ID/topics/$PUBSUB_TOPIC exists"
else
    echo "  ❌ FAIL: Topic $PUBSUB_TOPIC does NOT exist"
    echo "     Create it in GCP Console: https://console.cloud.google.com/cloudpubsub/topic/list"
    exit 1
fi

# Check 4: Service account has billing.projectManager role
echo ""
echo "✓ Check 4: Service account permissions"
if gcloud projects get-iam-policy "$PROJECT_ID" --flatten="bindings[].members" --filter="bindings.members:$SERVICE_ACCOUNT AND bindings.role:roles/billing.projectManager" --format="value(bindings.role)" 2>/dev/null | grep -q "billing.projectManager"; then
    echo "  ✅ PASS: $SERVICE_ACCOUNT has roles/billing.projectManager"
else
    echo "  ❌ FAIL: $SERVICE_ACCOUNT does NOT have roles/billing.projectManager"
    echo "     Grant it at: https://console.cloud.google.com/billing/$BILLING_ACCOUNT/iam-admin"
    exit 1
fi

# Check 5: Budget at $0.01 connected to Pub/Sub
echo ""
echo "✓ Check 5: Billing budget at \$0.01"
BUDGET_AMOUNT=$(gcloud billing budgets list --billing-account="$BILLING_ACCOUNT" --format="table(displayName,amount.specifiedAmount.nanos)" 2>/dev/null | grep -i "seedling" | awk '{print $NF}')
if [ "$BUDGET_AMOUNT" = "10000000" ]; then
    echo "  ✅ PASS: Budget set to \$0.01 USD"
else
    echo "  ⚠️  WARNING: Budget amount is $BUDGET_AMOUNT nanos (expected 10000000 = \$0.01)"
fi

PUBSUB_CHECK=$(gcloud billing budgets list --billing-account="$BILLING_ACCOUNT" --format="value(notificationsRule.pubsubTopic)" 2>/dev/null | grep -i "billing-kill-switch")
if [ ! -z "$PUBSUB_CHECK" ]; then
    echo "  ✅ PASS: Budget connected to billing-kill-switch Pub/Sub topic"
else
    echo "  ❌ FAIL: Budget NOT connected to billing-kill-switch topic"
    echo "     Update budget at: https://console.cloud.google.com/billing/budgets"
    exit 1
fi

echo ""
echo "========================================"
echo "✅ All preflight checks passed!"
echo ""
echo "Safe to deploy Cloud Functions."
echo "Deploy command: firebase deploy --only functions"
