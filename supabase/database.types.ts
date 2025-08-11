export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instanciate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "12.2.12 (cd3cf9e)"
  }
  public: {
    Tables: {
      ai_agents: {
        Row: {
          agent_name: string
          ai_agent_id: string
          branding_info: Json | null
          coach_id: string
          created_at: string | null
          updated_at: string | null
        }
        Insert: {
          agent_name: string
          ai_agent_id?: string
          branding_info?: Json | null
          coach_id: string
          created_at?: string | null
          updated_at?: string | null
        }
        Update: {
          agent_name?: string
          ai_agent_id?: string
          branding_info?: Json | null
          coach_id?: string
          created_at?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "ai_agents_coach_id_fkey"
            columns: ["coach_id"]
            isOneToOne: false
            referencedRelation: "coaches"
            referencedColumns: ["coach_id"]
          },
        ]
      }
      ai_interactions: {
        Row: {
          ai_agent_id: string
          client_id: string
          content: string | null
          interaction_id: string
          interaction_type: string
          session_id: string | null
          timestamp: string | null
        }
        Insert: {
          ai_agent_id: string
          client_id: string
          content?: string | null
          interaction_id?: string
          interaction_type: string
          session_id?: string | null
          timestamp?: string | null
        }
        Update: {
          ai_agent_id?: string
          client_id?: string
          content?: string | null
          interaction_id?: string
          interaction_type?: string
          session_id?: string | null
          timestamp?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "ai_interactions_ai_agent_id_fkey"
            columns: ["ai_agent_id"]
            isOneToOne: false
            referencedRelation: "ai_agents"
            referencedColumns: ["ai_agent_id"]
          },
          {
            foreignKeyName: "ai_interactions_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["client_id"]
          },
          {
            foreignKeyName: "ai_interactions_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "workout_sessions"
            referencedColumns: ["session_id"]
          },
        ]
      }
      badges: {
        Row: {
          badge_id: string
          description: string | null
          icon_url: string | null
          name: string
        }
        Insert: {
          badge_id?: string
          description?: string | null
          icon_url?: string | null
          name: string
        }
        Update: {
          badge_id?: string
          description?: string | null
          icon_url?: string | null
          name?: string
        }
        Relationships: []
      }
      client_badges: {
        Row: {
          badge_id: string
          client_badge_id: string
          client_id: string
          earned_at: string | null
        }
        Insert: {
          badge_id: string
          client_badge_id?: string
          client_id: string
          earned_at?: string | null
        }
        Update: {
          badge_id?: string
          client_badge_id?: string
          client_id?: string
          earned_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "client_badges_badge_id_fkey"
            columns: ["badge_id"]
            isOneToOne: false
            referencedRelation: "badges"
            referencedColumns: ["badge_id"]
          },
          {
            foreignKeyName: "client_badges_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["client_id"]
          },
        ]
      }
      client_progress: {
        Row: {
          body_fat_percentage: number | null
          client_id: string
          date: string
          muscle_mass: number | null
          progress_id: string
          weight: number | null
        }
        Insert: {
          body_fat_percentage?: number | null
          client_id: string
          date?: string
          muscle_mass?: number | null
          progress_id?: string
          weight?: number | null
        }
        Update: {
          body_fat_percentage?: number | null
          client_id?: string
          date?: string
          muscle_mass?: number | null
          progress_id?: string
          weight?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "client_progress_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["client_id"]
          },
        ]
      }
      clients: {
        Row: {
          client_id: string
          coach_id: string | null
          date_of_birth: string | null
          fitness_goals: string | null
          gender: string | null
          health_conditions: string | null
          height: number | null
          onboarding_completed: boolean | null
          preferred_activity_level: string | null
          target_calories_per_day: number | null
          weight: number | null
        }
        Insert: {
          client_id: string
          coach_id?: string | null
          date_of_birth?: string | null
          fitness_goals?: string | null
          gender?: string | null
          health_conditions?: string | null
          height?: number | null
          onboarding_completed?: boolean | null
          preferred_activity_level?: string | null
          target_calories_per_day?: number | null
          weight?: number | null
        }
        Update: {
          client_id?: string
          coach_id?: string | null
          date_of_birth?: string | null
          fitness_goals?: string | null
          gender?: string | null
          health_conditions?: string | null
          height?: number | null
          onboarding_completed?: boolean | null
          preferred_activity_level?: string | null
          target_calories_per_day?: number | null
          weight?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "clients_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "clients_coach_id_fkey"
            columns: ["coach_id"]
            isOneToOne: false
            referencedRelation: "coaches"
            referencedColumns: ["coach_id"]
          },
        ]
      }
      coaches: {
        Row: {
          bio: string | null
          certifications: string[] | null
          coach_id: string
          specialties: string[] | null
        }
        Insert: {
          bio?: string | null
          certifications?: string[] | null
          coach_id: string
          specialties?: string[] | null
        }
        Update: {
          bio?: string | null
          certifications?: string[] | null
          coach_id?: string
          specialties?: string[] | null
        }
        Relationships: [
          {
            foreignKeyName: "coaches_coach_id_fkey"
            columns: ["coach_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      exercises: {
        Row: {
          created_at: string | null
          description: string | null
          equipment_needed: string[] | null
          exercise_id: string
          muscle_groups: string[] | null
          name: string
          updated_at: string | null
          video_url: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          equipment_needed?: string[] | null
          exercise_id?: string
          muscle_groups?: string[] | null
          name: string
          updated_at?: string | null
          video_url?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          equipment_needed?: string[] | null
          exercise_id?: string
          muscle_groups?: string[] | null
          name?: string
          updated_at?: string | null
          video_url?: string | null
        }
        Relationships: []
      }
      feedback: {
        Row: {
          content: string
          exercise_id: string | null
          feedback_id: string
          feedback_type: string
          session_id: string
          timestamp: string | null
        }
        Insert: {
          content: string
          exercise_id?: string | null
          feedback_id?: string
          feedback_type: string
          session_id: string
          timestamp?: string | null
        }
        Update: {
          content?: string
          exercise_id?: string | null
          feedback_id?: string
          feedback_type?: string
          session_id?: string
          timestamp?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "feedback_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["exercise_id"]
          },
          {
            foreignKeyName: "feedback_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "workout_sessions"
            referencedColumns: ["session_id"]
          },
        ]
      }
      gamification: {
        Row: {
          client_id: string
          gamification_id: string
          level: number | null
          points: number | null
        }
        Insert: {
          client_id: string
          gamification_id?: string
          level?: number | null
          points?: number | null
        }
        Update: {
          client_id?: string
          gamification_id?: string
          level?: number | null
          points?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "gamification_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["client_id"]
          },
        ]
      }
      payment_history: {
        Row: {
          amount: number
          currency: string
          payment_date: string | null
          payment_id: string
          status: string
          stripe_invoice_id: string | null
          subscription_id: string
        }
        Insert: {
          amount: number
          currency?: string
          payment_date?: string | null
          payment_id?: string
          status?: string
          stripe_invoice_id?: string | null
          subscription_id: string
        }
        Update: {
          amount?: number
          currency?: string
          payment_date?: string | null
          payment_id?: string
          status?: string
          stripe_invoice_id?: string | null
          subscription_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "payment_history_subscription_id_fkey"
            columns: ["subscription_id"]
            isOneToOne: false
            referencedRelation: "user_subscriptions"
            referencedColumns: ["subscription_id"]
          },
        ]
      }
      performance_metrics: {
        Row: {
          exercise_id: string
          metric_id: string
          reps_completed: number | null
          session_id: string
          time_taken: number | null
          weight_used: number | null
        }
        Insert: {
          exercise_id: string
          metric_id?: string
          reps_completed?: number | null
          session_id: string
          time_taken?: number | null
          weight_used?: number | null
        }
        Update: {
          exercise_id?: string
          metric_id?: string
          reps_completed?: number | null
          session_id?: string
          time_taken?: number | null
          weight_used?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "performance_metrics_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["exercise_id"]
          },
          {
            foreignKeyName: "performance_metrics_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "workout_sessions"
            referencedColumns: ["session_id"]
          },
        ]
      }
      roles: {
        Row: {
          role_id: string
          role_name: string
        }
        Insert: {
          role_id?: string
          role_name: string
        }
        Update: {
          role_id?: string
          role_name?: string
        }
        Relationships: []
      }
      subscription_plans: {
        Row: {
          billing_cycle: string
          created_at: string | null
          description: string | null
          features: Json | null
          name: string
          plan_id: string
          price: number
          updated_at: string | null
        }
        Insert: {
          billing_cycle?: string
          created_at?: string | null
          description?: string | null
          features?: Json | null
          name: string
          plan_id?: string
          price: number
          updated_at?: string | null
        }
        Update: {
          billing_cycle?: string
          created_at?: string | null
          description?: string | null
          features?: Json | null
          name?: string
          plan_id?: string
          price?: number
          updated_at?: string | null
        }
        Relationships: []
      }
      trainer_profiles: {
        Row: {
          certifications: string[] | null
          coaching_experience: string | null
          created_at: string | null
          custom_pronouns: string | null
          descriptive_words: string[] | null
          equipment_details: string | null
          experience_level: string
          full_name: string
          id: string
          motivation: string | null
          nickname: string | null
          pronouns: string | null
          training_philosophy: string[] | null
          updated_at: string | null
          user_type: string | null
        }
        Insert: {
          certifications?: string[] | null
          coaching_experience?: string | null
          created_at?: string | null
          custom_pronouns?: string | null
          descriptive_words?: string[] | null
          equipment_details?: string | null
          experience_level: string
          full_name: string
          id: string
          motivation?: string | null
          nickname?: string | null
          pronouns?: string | null
          training_philosophy?: string[] | null
          updated_at?: string | null
          user_type?: string | null
        }
        Update: {
          certifications?: string[] | null
          coaching_experience?: string | null
          created_at?: string | null
          custom_pronouns?: string | null
          descriptive_words?: string[] | null
          equipment_details?: string | null
          experience_level?: string
          full_name?: string
          id?: string
          motivation?: string | null
          nickname?: string | null
          pronouns?: string | null
          training_philosophy?: string[] | null
          updated_at?: string | null
          user_type?: string | null
        }
        Relationships: []
      }
      user_settings: {
        Row: {
          language: string | null
          notification_enabled: boolean | null
          setting_id: string
          theme: string | null
          user_id: string
        }
        Insert: {
          language?: string | null
          notification_enabled?: boolean | null
          setting_id?: string
          theme?: string | null
          user_id: string
        }
        Update: {
          language?: string | null
          notification_enabled?: boolean | null
          setting_id?: string
          theme?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_settings_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_subscriptions: {
        Row: {
          end_date: string | null
          plan_id: string
          start_date: string
          status: string
          stripe_subscription_id: string | null
          subscription_id: string
          user_id: string
        }
        Insert: {
          end_date?: string | null
          plan_id: string
          start_date?: string
          status?: string
          stripe_subscription_id?: string | null
          subscription_id?: string
          user_id: string
        }
        Update: {
          end_date?: string | null
          plan_id?: string
          start_date?: string
          status?: string
          stripe_subscription_id?: string | null
          subscription_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_subscriptions_plan_id_fkey"
            columns: ["plan_id"]
            isOneToOne: false
            referencedRelation: "subscription_plans"
            referencedColumns: ["plan_id"]
          },
          {
            foreignKeyName: "user_subscriptions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      users: {
        Row: {
          created_at: string | null
          date_of_birth: string | null
          email: string
          first_name: string | null
          gender: string | null
          id: string
          is_active: boolean | null
          last_login: string | null
          last_name: string | null
          role_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          date_of_birth?: string | null
          email: string
          first_name?: string | null
          gender?: string | null
          id?: string
          is_active?: boolean | null
          last_login?: string | null
          last_name?: string | null
          role_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          date_of_birth?: string | null
          email?: string
          first_name?: string | null
          gender?: string | null
          id?: string
          is_active?: boolean | null
          last_login?: string | null
          last_name?: string | null
          role_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "users_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
        ]
      }
      workout_exercises: {
        Row: {
          exercise_id: string
          order_num: number
          reps: number | null
          rest_time: number | null
          sets: number | null
          workout_exercise_id: string
          workout_id: string
        }
        Insert: {
          exercise_id: string
          order_num: number
          reps?: number | null
          rest_time?: number | null
          sets?: number | null
          workout_exercise_id?: string
          workout_id: string
        }
        Update: {
          exercise_id?: string
          order_num?: number
          reps?: number | null
          rest_time?: number | null
          sets?: number | null
          workout_exercise_id?: string
          workout_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workout_exercises_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["exercise_id"]
          },
          {
            foreignKeyName: "workout_exercises_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workouts"
            referencedColumns: ["workout_id"]
          },
        ]
      }
      workout_sessions: {
        Row: {
          client_id: string
          end_time: string | null
          feedback: string | null
          session_id: string
          start_time: string
          status: string
          workout_id: string
        }
        Insert: {
          client_id: string
          end_time?: string | null
          feedback?: string | null
          session_id?: string
          start_time?: string
          status?: string
          workout_id: string
        }
        Update: {
          client_id?: string
          end_time?: string | null
          feedback?: string | null
          session_id?: string
          start_time?: string
          status?: string
          workout_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workout_sessions_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["client_id"]
          },
          {
            foreignKeyName: "workout_sessions_workout_id_fkey"
            columns: ["workout_id"]
            isOneToOne: false
            referencedRelation: "workouts"
            referencedColumns: ["workout_id"]
          },
        ]
      }
      workouts: {
        Row: {
          created_at: string | null
          creator_id: string
          description: string | null
          difficulty_level: string | null
          duration: number | null
          name: string
          updated_at: string | null
          workout_id: string
        }
        Insert: {
          created_at?: string | null
          creator_id: string
          description?: string | null
          difficulty_level?: string | null
          duration?: number | null
          name: string
          updated_at?: string | null
          workout_id?: string
        }
        Update: {
          created_at?: string | null
          creator_id?: string
          description?: string | null
          difficulty_level?: string | null
          duration?: number | null
          name?: string
          updated_at?: string | null
          workout_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workouts_creator_id_fkey"
            columns: ["creator_id"]
            isOneToOne: false
            referencedRelation: "coaches"
            referencedColumns: ["coach_id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
