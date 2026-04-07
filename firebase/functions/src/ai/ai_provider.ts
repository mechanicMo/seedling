import type {
  ParentGuidanceParams,
  ParentGuidanceResponse,
  SessionReportParams,
  SessionReport,
} from './types.js';

export interface AIProvider {
  /**
   * Generate a parent guidance response grounded in retrieved ParentGuides.
   * Must not fabricate — all claims must come from retrievedGuides.
   */
  getParentGuidance(
    params: ParentGuidanceParams
  ): Promise<ParentGuidanceResponse>;

  /**
   * Generate a post-session report for the parent.
   * Must not speculate about child development or diagnose.
   */
  generateSessionReport(
    params: SessionReportParams
  ): Promise<SessionReport>;
}
