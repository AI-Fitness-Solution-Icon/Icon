-- Migration: Create trainer_profiles table
-- Description: Creates the trainer_profiles table for storing trainer onboarding data
-- Date: 2024-01-XX

-- Create trainer_profiles table
CREATE TABLE IF NOT EXISTS trainer_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  pronouns TEXT,
  custom_pronouns TEXT,
  nickname TEXT,
  experience_level TEXT NOT NULL,
  descriptive_words TEXT[] DEFAULT '{}',
  motivation TEXT,
  certifications TEXT[] DEFAULT '{}',
  coaching_experience TEXT,
  equipment_details TEXT,
  training_philosophy TEXT[] DEFAULT '{}',
  user_type TEXT DEFAULT 'trainer',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_trainer_profiles_user_type ON trainer_profiles(user_type);
CREATE INDEX IF NOT EXISTS idx_trainer_profiles_experience_level ON trainer_profiles(experience_level);
CREATE INDEX IF NOT EXISTS idx_trainer_profiles_created_at ON trainer_profiles(created_at);

-- Enable Row Level Security (RLS)
ALTER TABLE trainer_profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can view their own profile
CREATE POLICY "Users can view own profile" ON trainer_profiles
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON trainer_profiles
  FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON trainer_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Users can delete their own profile
CREATE POLICY "Users can delete own profile" ON trainer_profiles
  FOR DELETE USING (auth.uid() = id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_trainer_profiles_updated_at
  BEFORE UPDATE ON trainer_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Add comments for documentation
COMMENT ON TABLE trainer_profiles IS 'Stores trainer profile information collected during onboarding';
COMMENT ON COLUMN trainer_profiles.id IS 'References auth.users(id) - the user account ID';
COMMENT ON COLUMN trainer_profiles.full_name IS 'Trainer full name (required)';
COMMENT ON COLUMN trainer_profiles.pronouns IS 'Selected pronouns (He/Him, She/Her, They/Them, Custom)';
COMMENT ON COLUMN trainer_profiles.custom_pronouns IS 'Custom pronouns when "Custom" is selected';
COMMENT ON COLUMN trainer_profiles.nickname IS 'Optional nickname';
COMMENT ON COLUMN trainer_profiles.experience_level IS 'Experience level (< 1 year, 1-3 years, 3-5 years, 5+ years)';
COMMENT ON COLUMN trainer_profiles.descriptive_words IS 'Array of selected descriptive words (max 3)';
COMMENT ON COLUMN trainer_profiles.motivation IS 'Trainer motivation text';
COMMENT ON COLUMN trainer_profiles.certifications IS 'Array of selected certifications';
COMMENT ON COLUMN trainer_profiles.coaching_experience IS 'Coaching experience description';
COMMENT ON COLUMN trainer_profiles.equipment_details IS 'Optional equipment details';
COMMENT ON COLUMN trainer_profiles.training_philosophy IS 'Array of selected training principles';
COMMENT ON COLUMN trainer_profiles.user_type IS 'User type (default: trainer)';
COMMENT ON COLUMN trainer_profiles.created_at IS 'Timestamp when profile was created';
COMMENT ON COLUMN trainer_profiles.updated_at IS 'Timestamp when profile was last updated'; 