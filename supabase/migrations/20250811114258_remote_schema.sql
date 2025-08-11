SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";
COMMENT ON SCHEMA "public" IS 'standard public schema';
CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";
SET default_tablespace = '';
SET default_table_access_method = "heap";
CREATE TABLE IF NOT EXISTS "public"."ai_agents" (
    "ai_agent_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "coach_id" "uuid" NOT NULL,
    "agent_name" character varying(100) NOT NULL,
    "branding_info" "jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."ai_agents" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ai_interactions" (
    "interaction_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "ai_agent_id" "uuid" NOT NULL,
    "session_id" "uuid",
    "interaction_type" character varying(50) NOT NULL,
    "content" "text",
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."ai_interactions" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."badges" (
    "badge_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" "text",
    "icon_url" "text"
);
ALTER TABLE "public"."badges" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."client_badges" (
    "client_badge_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "badge_id" "uuid" NOT NULL,
    "earned_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."client_badges" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."client_progress" (
    "progress_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "weight" double precision,
    "body_fat_percentage" double precision,
    "muscle_mass" double precision,
    CONSTRAINT "client_progress_body_fat_percentage_check" CHECK ((("body_fat_percentage" >= (0)::double precision) AND ("body_fat_percentage" <= (100)::double precision))),
    CONSTRAINT "client_progress_muscle_mass_check" CHECK (("muscle_mass" >= (0)::double precision)),
    CONSTRAINT "client_progress_weight_check" CHECK (("weight" > (0)::double precision))
);
ALTER TABLE "public"."client_progress" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."clients" (
    "client_id" "uuid" NOT NULL,
    "coach_id" "uuid",
    "date_of_birth" "date",
    "gender" character varying(50),
    "height" double precision,
    "weight" double precision,
    "fitness_goals" "text",
    "health_conditions" "text",
    "preferred_activity_level" character varying(50) DEFAULT 'Beginner'::character varying,
    "target_calories_per_day" integer,
    "onboarding_completed" boolean DEFAULT false,
    CONSTRAINT "clients_target_calories_per_day_check" CHECK ((("target_calories_per_day" >= 1000) AND ("target_calories_per_day" <= 5000)))
);
ALTER TABLE "public"."clients" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."coaches" (
    "coach_id" "uuid" NOT NULL,
    "bio" "text",
    "certifications" "text"[],
    "specialties" "text"[]
);
ALTER TABLE "public"."coaches" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."exercises" (
    "exercise_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" "text",
    "muscle_groups" "text"[] DEFAULT '{}'::"text"[],
    "equipment_needed" "text"[],
    "video_url" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."exercises" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."feedback" (
    "feedback_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "exercise_id" "uuid",
    "feedback_type" character varying(50) NOT NULL,
    "content" "text" NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."feedback" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."gamification" (
    "gamification_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "points" integer DEFAULT 0,
    "level" integer DEFAULT 1,
    CONSTRAINT "gamification_level_check" CHECK (("level" > 0)),
    CONSTRAINT "gamification_points_check" CHECK (("points" >= 0))
);
ALTER TABLE "public"."gamification" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."payment_history" (
    "payment_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "subscription_id" "uuid" NOT NULL,
    "amount" double precision NOT NULL,
    "currency" character varying(10) DEFAULT 'USD'::character varying NOT NULL,
    "payment_date" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "stripe_invoice_id" "text",
    "status" character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    CONSTRAINT "payment_history_amount_check" CHECK (("amount" > (0)::double precision))
);
ALTER TABLE "public"."payment_history" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."performance_metrics" (
    "metric_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "exercise_id" "uuid" NOT NULL,
    "reps_completed" integer,
    "weight_used" double precision,
    "time_taken" integer,
    CONSTRAINT "performance_metrics_reps_completed_check" CHECK (("reps_completed" >= 0)),
    CONSTRAINT "performance_metrics_time_taken_check" CHECK (("time_taken" >= 0)),
    CONSTRAINT "performance_metrics_weight_used_check" CHECK (("weight_used" >= (0)::double precision))
);
ALTER TABLE "public"."performance_metrics" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."roles" (
    "role_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "role_name" character varying(50) NOT NULL
);
ALTER TABLE "public"."roles" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."subscription_plans" (
    "plan_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" "text",
    "price" double precision NOT NULL,
    "billing_cycle" character varying(50) DEFAULT 'monthly'::character varying NOT NULL,
    "features" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "subscription_plans_price_check" CHECK (("price" >= (0)::double precision))
);
ALTER TABLE "public"."subscription_plans" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."trainer_profiles" (
    "id" "uuid" NOT NULL,
    "full_name" "text" NOT NULL,
    "pronouns" "text",
    "custom_pronouns" "text",
    "nickname" "text",
    "experience_level" "text" NOT NULL,
    "descriptive_words" "text"[],
    "motivation" "text",
    "certifications" "text"[],
    "coaching_experience" "text",
    "equipment_details" "text",
    "training_philosophy" "text"[],
    "user_type" "text" DEFAULT 'trainer'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."trainer_profiles" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."user_settings" (
    "setting_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "theme" character varying(50) DEFAULT 'light'::character varying,
    "notification_enabled" boolean DEFAULT true,
    "language" character varying(50) DEFAULT 'en'::character varying
);
ALTER TABLE "public"."user_settings" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."user_subscriptions" (
    "subscription_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "plan_id" "uuid" NOT NULL,
    "start_date" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "end_date" timestamp with time zone,
    "status" character varying(50) DEFAULT 'active'::character varying NOT NULL,
    "stripe_subscription_id" "text"
);
ALTER TABLE "public"."user_subscriptions" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."users" (
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "role_id" "uuid" NOT NULL,
    "first_name" character varying(100),
    "last_name" character varying(100),
    "email" character varying(255) NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "last_login" timestamp with time zone DEFAULT "now"(),
    "is_active" boolean DEFAULT true,
    "date_of_birth" "date",
    "gender" "text" DEFAULT ''::"text"
);
ALTER TABLE "public"."users" OWNER TO "postgres";
COMMENT ON TABLE "public"."users" IS 'Contains the users informations.';
COMMENT ON COLUMN "public"."users"."date_of_birth" IS 'Date of birth of the user.';
COMMENT ON COLUMN "public"."users"."gender" IS 'Gender of theu ser';
CREATE TABLE IF NOT EXISTS "public"."workout_exercises" (
    "workout_exercise_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "workout_id" "uuid" NOT NULL,
    "exercise_id" "uuid" NOT NULL,
    "order_num" integer NOT NULL,
    "sets" integer,
    "reps" integer,
    "rest_time" integer,
    CONSTRAINT "workout_exercises_order_num_check" CHECK (("order_num" >= 0)),
    CONSTRAINT "workout_exercises_reps_check" CHECK (("reps" > 0)),
    CONSTRAINT "workout_exercises_rest_time_check" CHECK (("rest_time" >= 0)),
    CONSTRAINT "workout_exercises_sets_check" CHECK (("sets" > 0))
);
ALTER TABLE "public"."workout_exercises" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."workout_sessions" (
    "session_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "workout_id" "uuid" NOT NULL,
    "start_time" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "end_time" timestamp with time zone,
    "status" character varying(50) DEFAULT 'in_progress'::character varying NOT NULL,
    "feedback" "text"
);
ALTER TABLE "public"."workout_sessions" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."workouts" (
    "workout_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "creator_id" "uuid" NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" "text",
    "duration" integer,
    "difficulty_level" character varying(50) DEFAULT 'Beginner'::character varying,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "workouts_duration_check" CHECK (("duration" > 0))
);
ALTER TABLE "public"."workouts" OWNER TO "postgres";
ALTER TABLE ONLY "public"."ai_agents"
    ADD CONSTRAINT "ai_agents_pkey" PRIMARY KEY ("ai_agent_id");
ALTER TABLE ONLY "public"."ai_interactions"
    ADD CONSTRAINT "ai_interactions_pkey" PRIMARY KEY ("interaction_id");
ALTER TABLE ONLY "public"."badges"
    ADD CONSTRAINT "badges_pkey" PRIMARY KEY ("badge_id");
ALTER TABLE ONLY "public"."client_badges"
    ADD CONSTRAINT "client_badges_client_id_badge_id_key" UNIQUE ("client_id", "badge_id");
ALTER TABLE ONLY "public"."client_badges"
    ADD CONSTRAINT "client_badges_pkey" PRIMARY KEY ("client_badge_id");
ALTER TABLE ONLY "public"."client_progress"
    ADD CONSTRAINT "client_progress_pkey" PRIMARY KEY ("progress_id");
ALTER TABLE ONLY "public"."clients"
    ADD CONSTRAINT "clients_pkey" PRIMARY KEY ("client_id");
ALTER TABLE ONLY "public"."coaches"
    ADD CONSTRAINT "coaches_pkey" PRIMARY KEY ("coach_id");
ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "exercises_pkey" PRIMARY KEY ("exercise_id");
ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "feedback_pkey" PRIMARY KEY ("feedback_id");
ALTER TABLE ONLY "public"."gamification"
    ADD CONSTRAINT "gamification_pkey" PRIMARY KEY ("gamification_id");
ALTER TABLE ONLY "public"."payment_history"
    ADD CONSTRAINT "payment_history_pkey" PRIMARY KEY ("payment_id");
ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_pkey" PRIMARY KEY ("metric_id");
ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("role_id");
ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_role_name_key" UNIQUE ("role_name");
ALTER TABLE ONLY "public"."subscription_plans"
    ADD CONSTRAINT "subscription_plans_pkey" PRIMARY KEY ("plan_id");
ALTER TABLE ONLY "public"."trainer_profiles"
    ADD CONSTRAINT "trainer_profiles_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_pkey" PRIMARY KEY ("setting_id");
ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_pkey" PRIMARY KEY ("subscription_id");
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("user_id");
ALTER TABLE ONLY "public"."workout_exercises"
    ADD CONSTRAINT "workout_exercises_pkey" PRIMARY KEY ("workout_exercise_id");
ALTER TABLE ONLY "public"."workout_sessions"
    ADD CONSTRAINT "workout_sessions_pkey" PRIMARY KEY ("session_id");
ALTER TABLE ONLY "public"."workouts"
    ADD CONSTRAINT "workouts_pkey" PRIMARY KEY ("workout_id");
CREATE INDEX "idx_ai_agents_coach" ON "public"."ai_agents" USING "btree" ("coach_id");
CREATE INDEX "idx_ai_interactions_agent" ON "public"."ai_interactions" USING "btree" ("ai_agent_id");
CREATE INDEX "idx_ai_interactions_client" ON "public"."ai_interactions" USING "btree" ("client_id");
CREATE INDEX "idx_client_badges_badge" ON "public"."client_badges" USING "btree" ("badge_id");
CREATE INDEX "idx_client_badges_client" ON "public"."client_badges" USING "btree" ("client_id");
CREATE INDEX "idx_client_progress_client" ON "public"."client_progress" USING "btree" ("client_id");
CREATE INDEX "idx_clients_coach" ON "public"."clients" USING "btree" ("coach_id");
CREATE INDEX "idx_feedback_exercise" ON "public"."feedback" USING "btree" ("exercise_id");
CREATE INDEX "idx_feedback_session" ON "public"."feedback" USING "btree" ("session_id");
CREATE UNIQUE INDEX "idx_gamification_client" ON "public"."gamification" USING "btree" ("client_id");
CREATE INDEX "idx_payment_history_subscription" ON "public"."payment_history" USING "btree" ("subscription_id");
CREATE INDEX "idx_performance_metrics_exercise" ON "public"."performance_metrics" USING "btree" ("exercise_id");
CREATE INDEX "idx_performance_metrics_session" ON "public"."performance_metrics" USING "btree" ("session_id");
CREATE UNIQUE INDEX "idx_user_settings_user" ON "public"."user_settings" USING "btree" ("user_id");
CREATE INDEX "idx_user_subscriptions_plan" ON "public"."user_subscriptions" USING "btree" ("plan_id");
CREATE INDEX "idx_user_subscriptions_user" ON "public"."user_subscriptions" USING "btree" ("user_id");
CREATE INDEX "idx_users_email" ON "public"."users" USING "btree" ("email");
CREATE INDEX "idx_users_role" ON "public"."users" USING "btree" ("role_id");
CREATE INDEX "idx_workout_exercises_exercise" ON "public"."workout_exercises" USING "btree" ("exercise_id");
CREATE INDEX "idx_workout_exercises_workout" ON "public"."workout_exercises" USING "btree" ("workout_id");
CREATE INDEX "idx_workout_sessions_client" ON "public"."workout_sessions" USING "btree" ("client_id");
CREATE INDEX "idx_workout_sessions_workout" ON "public"."workout_sessions" USING "btree" ("workout_id");
CREATE INDEX "idx_workouts_creator" ON "public"."workouts" USING "btree" ("creator_id");
ALTER TABLE ONLY "public"."ai_agents"
    ADD CONSTRAINT "ai_agents_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "public"."coaches"("coach_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."ai_interactions"
    ADD CONSTRAINT "ai_interactions_ai_agent_id_fkey" FOREIGN KEY ("ai_agent_id") REFERENCES "public"."ai_agents"("ai_agent_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."ai_interactions"
    ADD CONSTRAINT "ai_interactions_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("client_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."ai_interactions"
    ADD CONSTRAINT "ai_interactions_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."workout_sessions"("session_id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."client_badges"
    ADD CONSTRAINT "client_badges_badge_id_fkey" FOREIGN KEY ("badge_id") REFERENCES "public"."badges"("badge_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."client_badges"
    ADD CONSTRAINT "client_badges_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("client_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."client_progress"
    ADD CONSTRAINT "client_progress_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("client_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."clients"
    ADD CONSTRAINT "clients_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."clients"
    ADD CONSTRAINT "clients_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "public"."coaches"("coach_id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."coaches"
    ADD CONSTRAINT "coaches_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "feedback_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."exercises"("exercise_id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."feedback"
    ADD CONSTRAINT "feedback_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."workout_sessions"("session_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."gamification"
    ADD CONSTRAINT "gamification_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("client_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."payment_history"
    ADD CONSTRAINT "payment_history_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "public"."user_subscriptions"("subscription_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."exercises"("exercise_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."performance_metrics"
    ADD CONSTRAINT "performance_metrics_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."workout_sessions"("session_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."trainer_profiles"
    ADD CONSTRAINT "trainer_profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "public"."subscription_plans"("plan_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("role_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."workout_exercises"
    ADD CONSTRAINT "workout_exercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "public"."exercises"("exercise_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."workout_exercises"
    ADD CONSTRAINT "workout_exercises_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "public"."workouts"("workout_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."workout_sessions"
    ADD CONSTRAINT "workout_sessions_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("client_id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."workout_sessions"
    ADD CONSTRAINT "workout_sessions_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "public"."workouts"("workout_id") ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."workouts"
    ADD CONSTRAINT "workouts_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."coaches"("coach_id") ON DELETE CASCADE;
CREATE POLICY "Allow authenticated delete on ai_agents" ON "public"."ai_agents" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on ai_interactions" ON "public"."ai_interactions" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on badges" ON "public"."badges" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on client_badges" ON "public"."client_badges" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on client_progress" ON "public"."client_progress" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on clients" ON "public"."clients" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on coaches" ON "public"."coaches" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on exercises" ON "public"."exercises" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on feedback" ON "public"."feedback" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on gamification" ON "public"."gamification" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on payment_history" ON "public"."payment_history" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on performance_metrics" ON "public"."performance_metrics" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on roles" ON "public"."roles" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on subscription_plans" ON "public"."subscription_plans" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on trainer_profiles" ON "public"."trainer_profiles" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on user_settings" ON "public"."user_settings" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on user_subscriptions" ON "public"."user_subscriptions" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on users" ON "public"."users" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on workout_exercises" ON "public"."workout_exercises" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on workout_sessions" ON "public"."workout_sessions" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated delete on workouts" ON "public"."workouts" FOR DELETE TO "authenticated" USING (true);
CREATE POLICY "Allow authenticated insert on ai_agents" ON "public"."ai_agents" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on ai_interactions" ON "public"."ai_interactions" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on badges" ON "public"."badges" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on client_badges" ON "public"."client_badges" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on client_progress" ON "public"."client_progress" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on clients" ON "public"."clients" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on coaches" ON "public"."coaches" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on exercises" ON "public"."exercises" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on feedback" ON "public"."feedback" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on gamification" ON "public"."gamification" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on payment_history" ON "public"."payment_history" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on performance_metrics" ON "public"."performance_metrics" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on roles" ON "public"."roles" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on subscription_plans" ON "public"."subscription_plans" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on trainer_profiles" ON "public"."trainer_profiles" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on user_settings" ON "public"."user_settings" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on user_subscriptions" ON "public"."user_subscriptions" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on users" ON "public"."users" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on workout_exercises" ON "public"."workout_exercises" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on workout_sessions" ON "public"."workout_sessions" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated insert on workouts" ON "public"."workouts" FOR INSERT TO "authenticated" WITH CHECK (true);
CREATE POLICY "Allow authenticated update on ai_agents" ON "public"."ai_agents" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on ai_interactions" ON "public"."ai_interactions" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on badges" ON "public"."badges" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on client_badges" ON "public"."client_badges" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on client_progress" ON "public"."client_progress" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on clients" ON "public"."clients" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on coaches" ON "public"."coaches" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on exercises" ON "public"."exercises" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on feedback" ON "public"."feedback" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on gamification" ON "public"."gamification" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on payment_history" ON "public"."payment_history" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on performance_metrics" ON "public"."performance_metrics" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on roles" ON "public"."roles" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on subscription_plans" ON "public"."subscription_plans" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on trainer_profiles" ON "public"."trainer_profiles" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on user_settings" ON "public"."user_settings" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on user_subscriptions" ON "public"."user_subscriptions" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on users" ON "public"."users" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on workout_exercises" ON "public"."workout_exercises" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on workout_sessions" ON "public"."workout_sessions" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated update on workouts" ON "public"."workouts" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read on ai_agents" ON "public"."ai_agents" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on ai_interactions" ON "public"."ai_interactions" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on badges" ON "public"."badges" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on client_badges" ON "public"."client_badges" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on client_progress" ON "public"."client_progress" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on clients" ON "public"."clients" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on coaches" ON "public"."coaches" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on exercises" ON "public"."exercises" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on feedback" ON "public"."feedback" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on gamification" ON "public"."gamification" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on payment_history" ON "public"."payment_history" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on performance_metrics" ON "public"."performance_metrics" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on roles" ON "public"."roles" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on subscription_plans" ON "public"."subscription_plans" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on trainer_profiles" ON "public"."trainer_profiles" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on user_settings" ON "public"."user_settings" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on user_subscriptions" ON "public"."user_subscriptions" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on users" ON "public"."users" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on workout_exercises" ON "public"."workout_exercises" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on workout_sessions" ON "public"."workout_sessions" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Allow public read on workouts" ON "public"."workouts" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Users can insert own profile" ON "public"."trainer_profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "id"));
CREATE POLICY "Users can update own profile" ON "public"."trainer_profiles" FOR UPDATE USING (("auth"."uid"() = "id"));
CREATE POLICY "Users can view own profile" ON "public"."trainer_profiles" FOR SELECT USING (("auth"."uid"() = "id"));
ALTER TABLE "public"."ai_agents" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ai_interactions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."badges" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."client_badges" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."client_progress" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."clients" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."coaches" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."exercises" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."feedback" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."gamification" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."payment_history" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."performance_metrics" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."roles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."subscription_plans" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."trainer_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."user_settings" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."user_subscriptions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."workout_exercises" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."workout_sessions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."workouts" ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT ALL ON TABLE "public"."ai_agents" TO "anon";
GRANT ALL ON TABLE "public"."ai_agents" TO "authenticated";
GRANT ALL ON TABLE "public"."ai_agents" TO "service_role";
GRANT ALL ON TABLE "public"."ai_interactions" TO "anon";
GRANT ALL ON TABLE "public"."ai_interactions" TO "authenticated";
GRANT ALL ON TABLE "public"."ai_interactions" TO "service_role";
GRANT ALL ON TABLE "public"."badges" TO "anon";
GRANT ALL ON TABLE "public"."badges" TO "authenticated";
GRANT ALL ON TABLE "public"."badges" TO "service_role";
GRANT ALL ON TABLE "public"."client_badges" TO "anon";
GRANT ALL ON TABLE "public"."client_badges" TO "authenticated";
GRANT ALL ON TABLE "public"."client_badges" TO "service_role";
GRANT ALL ON TABLE "public"."client_progress" TO "anon";
GRANT ALL ON TABLE "public"."client_progress" TO "authenticated";
GRANT ALL ON TABLE "public"."client_progress" TO "service_role";
GRANT ALL ON TABLE "public"."clients" TO "anon";
GRANT ALL ON TABLE "public"."clients" TO "authenticated";
GRANT ALL ON TABLE "public"."clients" TO "service_role";
GRANT ALL ON TABLE "public"."coaches" TO "anon";
GRANT ALL ON TABLE "public"."coaches" TO "authenticated";
GRANT ALL ON TABLE "public"."coaches" TO "service_role";
GRANT ALL ON TABLE "public"."exercises" TO "anon";
GRANT ALL ON TABLE "public"."exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."exercises" TO "service_role";
GRANT ALL ON TABLE "public"."feedback" TO "anon";
GRANT ALL ON TABLE "public"."feedback" TO "authenticated";
GRANT ALL ON TABLE "public"."feedback" TO "service_role";
GRANT ALL ON TABLE "public"."gamification" TO "anon";
GRANT ALL ON TABLE "public"."gamification" TO "authenticated";
GRANT ALL ON TABLE "public"."gamification" TO "service_role";
GRANT ALL ON TABLE "public"."payment_history" TO "anon";
GRANT ALL ON TABLE "public"."payment_history" TO "authenticated";
GRANT ALL ON TABLE "public"."payment_history" TO "service_role";
GRANT ALL ON TABLE "public"."performance_metrics" TO "anon";
GRANT ALL ON TABLE "public"."performance_metrics" TO "authenticated";
GRANT ALL ON TABLE "public"."performance_metrics" TO "service_role";
GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";
GRANT ALL ON TABLE "public"."subscription_plans" TO "anon";
GRANT ALL ON TABLE "public"."subscription_plans" TO "authenticated";
GRANT ALL ON TABLE "public"."subscription_plans" TO "service_role";
GRANT ALL ON TABLE "public"."trainer_profiles" TO "anon";
GRANT ALL ON TABLE "public"."trainer_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."trainer_profiles" TO "service_role";
GRANT ALL ON TABLE "public"."user_settings" TO "anon";
GRANT ALL ON TABLE "public"."user_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."user_settings" TO "service_role";
GRANT ALL ON TABLE "public"."user_subscriptions" TO "anon";
GRANT ALL ON TABLE "public"."user_subscriptions" TO "authenticated";
GRANT ALL ON TABLE "public"."user_subscriptions" TO "service_role";
GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";
GRANT ALL ON TABLE "public"."workout_exercises" TO "anon";
GRANT ALL ON TABLE "public"."workout_exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."workout_exercises" TO "service_role";
GRANT ALL ON TABLE "public"."workout_sessions" TO "anon";
GRANT ALL ON TABLE "public"."workout_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."workout_sessions" TO "service_role";
GRANT ALL ON TABLE "public"."workouts" TO "anon";
GRANT ALL ON TABLE "public"."workouts" TO "authenticated";
GRANT ALL ON TABLE "public"."workouts" TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";
RESET ALL;
