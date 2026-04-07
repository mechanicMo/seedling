import type { AIProvider } from './ai_provider.js';
import { GroqProvider } from './groq_provider.js';
import { AnthropicProvider } from './anthropic_provider.js';

interface ApiKeys {
  groqApiKey: string;
  anthropicApiKey: string;
}

/**
 * Returns the correct AIProvider based on the user's subscription tier.
 * Free → Groq (Llama 3.3 70B) — near-zero cost
 * Paid → Anthropic (Claude Sonnet) — premium quality
 */
export function getProviderForTier(
  tier: string,
  keys: ApiKeys
): AIProvider {
  if (tier === 'paid') {
    return new AnthropicProvider(keys.anthropicApiKey);
  }
  return new GroqProvider(keys.groqApiKey);
}
