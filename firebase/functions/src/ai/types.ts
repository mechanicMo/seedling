// Mirrors Firestore document schemas — keep in sync with Flutter models

export interface ParentGuide {
  id: string;
  title: string;
  category: string;
  age_ranges: string[];
  situation_tags: string[];
  quick_response: string;
  full_guide: string;
  research_basis: string[];
  do_this: string[];
  not_that: string[];
  follow_up_activity_ids: string[];
  published: boolean;
  version: number;
}

export interface ChildActivity {
  id: string;
  title: string;
  type: 'story' | 'game' | 'music' | 'movement' | 'video' | 'creative';
  age_ranges: string[];
  duration_minutes: number;
  media_refs: string[];
  skills_targeted: string[];
  learning_objectives: string[];
  parent_follow_up: string;
  published: boolean;
  version: number;
}

export interface ChildProfileContext {
  id: string;
  age_range: string;           // '0-3' | '3-7' | '7-12' — no name (COPPA)
  session_timer_minutes: number;
  content_selection: {
    enabled_categories: string[];
    enabled_activity_types: string[];
  };
}

export interface CompletedActivity {
  activity_id: string;
  type: string;
  duration_seconds: number;
  title: string;
  skills_targeted: string[];
  parent_follow_up: string;
}

export interface ParentGuidanceParams {
  situation: string;
  retrievedGuides: ParentGuide[];
  childProfile: ChildProfileContext;
}

export interface ParentGuidanceResponse {
  response: string;
  guide_refs: string[];   // IDs of ParentGuides used in the response
}

export interface SessionReportParams {
  activities: CompletedActivity[];
  childProfile: ChildProfileContext;
  session_duration_minutes: number;
}

export interface SessionReport {
  summary: string;
  skills_practiced: string[];
  parent_follow_ups: string[];
  ai_observations: string;
}
