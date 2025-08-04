-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. roles
CREATE TABLE roles (
  role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  role_name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. users
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role_id);

-- 3. coaches
CREATE TABLE coaches (
  coach_id UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
  bio TEXT,
  certifications TEXT[],
  specialties TEXT[]
);

-- 4. clients
CREATE TABLE clients (
  client_id UUID PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
  coach_id UUID REFERENCES coaches(coach_id) ON DELETE SET NULL,
  date_of_birth DATE,
  gender VARCHAR(50),
  height FLOAT,
  weight FLOAT,
  fitness_goals TEXT,
  health_conditions TEXT,
  preferred_activity_level VARCHAR(50) DEFAULT 'Beginner', 
  target_calories_per_day INT CHECK (target_calories_per_day BETWEEN 1000 AND 5000),
  onboarding_completed BOOLEAN DEFAULT FALSE
);
CREATE INDEX idx_clients_coach ON clients(coach_id);

-- 5. ai_agents
CREATE TABLE ai_agents (
  ai_agent_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  coach_id UUID NOT NULL REFERENCES coaches(coach_id) ON DELETE CASCADE,
  agent_name VARCHAR(100) NOT NULL,
  branding_info JSONB,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_ai_agents_coach ON ai_agents(coach_id);

-- 6. workouts
CREATE TABLE workouts (
  workout_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  creator_id UUID NOT NULL REFERENCES coaches(coach_id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  duration INT CHECK (duration > 0),
  difficulty_level VARCHAR(50) DEFAULT 'Beginner',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_workouts_creator ON workouts(creator_id);

-- 7. exercises
CREATE TABLE exercises (
  exercise_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  muscle_groups TEXT[] DEFAULT '{}',
  equipment_needed TEXT[],
  video_url TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. workout_exercises
CREATE TABLE workout_exercises (
  workout_exercise_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID NOT NULL REFERENCES workouts(workout_id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(exercise_id) ON DELETE CASCADE,
  order_num INT NOT NULL CHECK (order_num >= 0),
  sets INT CHECK (sets > 0),
  reps INT CHECK (reps > 0),
  rest_time INT CHECK (rest_time >= 0)
);
CREATE INDEX idx_workout_exercises_workout ON workout_exercises(workout_id);
CREATE INDEX idx_workout_exercises_exercise ON workout_exercises(exercise_id);

-- 9. subscription_plans
CREATE TABLE subscription_plans (
  plan_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price FLOAT NOT NULL CHECK (price >= 0),
  billing_cycle VARCHAR(50) NOT NULL DEFAULT 'monthly',
  features JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. user_subscriptions
CREATE TABLE user_subscriptions (
  subscription_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES subscription_plans(plan_id) ON DELETE RESTRICT,
  start_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_date TIMESTAMPTZ,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  stripe_subscription_id TEXT
);
CREATE INDEX idx_user_subscriptions_user ON user_subscriptions(user_id);
CREATE INDEX idx_user_subscriptions_plan ON user_subscriptions(plan_id);

-- 11. payment_history
CREATE TABLE payment_history (
  payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID NOT NULL REFERENCES user_subscriptions(subscription_id) ON DELETE CASCADE,
  amount FLOAT NOT NULL CHECK (amount > 0),
  currency VARCHAR(10) NOT NULL DEFAULT 'USD',
  payment_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  stripe_invoice_id TEXT,
  status VARCHAR(50) NOT NULL DEFAULT 'pending'
);
CREATE INDEX idx_payment_history_subscription ON payment_history(subscription_id);

-- 12. workout_sessions
CREATE TABLE workout_sessions (
  session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  workout_id UUID NOT NULL REFERENCES workouts(workout_id) ON DELETE RESTRICT,
  start_time TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_time TIMESTAMPTZ,
  status VARCHAR(50) NOT NULL DEFAULT 'in_progress',
  feedback TEXT
);
CREATE INDEX idx_workout_sessions_client ON workout_sessions(client_id);
CREATE INDEX idx_workout_sessions_workout ON workout_sessions(workout_id);

-- 13. performance_metrics
CREATE TABLE performance_metrics (
  metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES workout_sessions(session_id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(exercise_id) ON DELETE RESTRICT,
  reps_completed INT CHECK (reps_completed >= 0),
  weight_used FLOAT CHECK (weight_used >= 0),
  time_taken INT CHECK (time_taken >= 0)
);
CREATE INDEX idx_performance_metrics_session ON performance_metrics(session_id);
CREATE INDEX idx_performance_metrics_exercise ON performance_metrics(exercise_id);

-- 14. client_progress
CREATE TABLE client_progress (
  progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  weight FLOAT CHECK (weight > 0),
  body_fat_percentage FLOAT CHECK (body_fat_percentage BETWEEN 0 AND 100),
  muscle_mass FLOAT CHECK (muscle_mass >= 0)
);
CREATE INDEX idx_client_progress_client ON client_progress(client_id);

-- 15. ai_interactions
CREATE TABLE ai_interactions (
  interaction_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  ai_agent_id UUID NOT NULL REFERENCES ai_agents(ai_agent_id) ON DELETE RESTRICT,
  session_id UUID REFERENCES workout_sessions(session_id) ON DELETE SET NULL,
  interaction_type VARCHAR(50) NOT NULL,
  content TEXT,
  timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_ai_interactions_client ON ai_interactions(client_id);
CREATE INDEX idx_ai_interactions_agent ON ai_interactions(ai_agent_id);

-- 16. feedback
CREATE TABLE feedback (
  feedback_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES workout_sessions(session_id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(exercise_id) ON DELETE SET NULL,
  feedback_type VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_feedback_session ON feedback(session_id);
CREATE INDEX idx_feedback_exercise ON feedback(exercise_id);

-- 17. gamification
CREATE TABLE gamification (
  gamification_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  points INT DEFAULT 0 CHECK (points >= 0),
  level INT DEFAULT 1 CHECK (level > 0)
);
CREATE UNIQUE INDEX idx_gamification_client ON gamification(client_id);

-- 18. badges
CREATE TABLE badges (
  badge_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  icon_url TEXT
);

-- 19. client_badges
CREATE TABLE client_badges (
  client_badge_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(badge_id) ON DELETE RESTRICT,
  earned_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(client_id, badge_id)
);
CREATE INDEX idx_client_badges_client ON client_badges(client_id);
CREATE INDEX idx_client_badges_badge ON client_badges(badge_id);

-- 20. trainer_profiles
CREATE TABLE trainer_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  full_name TEXT NOT NULL,
  pronouns TEXT,
  custom_pronouns TEXT,
  nickname TEXT,
  experience_level TEXT NOT NULL,
  descriptive_words TEXT[],
  motivation TEXT,
  certifications TEXT[],
  coaching_experience TEXT,
  equipment_details TEXT,
  training_philosophy TEXT[],
  user_type TEXT DEFAULT 'trainer',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for trainer_profiles
ALTER TABLE trainer_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for trainer_profiles
CREATE POLICY "Users can view own profile" ON trainer_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON trainer_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON trainer_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 21. user_settings
CREATE TABLE user_settings (
  setting_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  theme VARCHAR(50) DEFAULT 'light',
  notification_enabled BOOLEAN DEFAULT TRUE,
  language VARCHAR(50) DEFAULT 'en'
);
CREATE UNIQUE INDEX idx_user_settings_user ON user_settings(user_id);

-- Insert sample data into roles
INSERT INTO roles (role_name) VALUES 
  ('admin'), 
  ('coach'), 
  ('client');

-- Insert sample users with corresponding roles
INSERT INTO users (role_id, first_name, last_name, email, password_hash)
VALUES 
  ((SELECT role_id FROM roles WHERE role_name = 'coach'), 'John', 'Doe', 'john.doe@iconfit.com', 'hashed_password_1'),
  ((SELECT role_id FROM roles WHERE role_name = 'client'), 'Jane', 'Smith', 'jane.smith@iconfit.com', 'hashed_password_2');

-- Insert sample coach
INSERT INTO coaches (coach_id) 
VALUES ((SELECT user_id FROM users WHERE email = 'john.doe@iconfit.com'));

-- Insert sample clients with additional onboarding data
INSERT INTO clients (
  client_id, 
  coach_id, 
  date_of_birth, 
  gender, 
  height, 
  weight, 
  fitness_goals, 
  health_conditions, 
  preferred_activity_level, 
  target_calories_per_day, 
  onboarding_completed
)
VALUES 
  (
    (SELECT user_id FROM users WHERE email = 'jane.smith@iconfit.com'), 
    (SELECT coach_id FROM coaches WHERE coach_id = (SELECT user_id FROM users WHERE email = 'john.doe@iconfit.com')),
    '1995-05-15', 
    'Female', 
    165.0, 
    60.0, 
    'Lose weight and build endurance', 
    'None', 
    'Moderate', 
    1800, 
    TRUE
  );