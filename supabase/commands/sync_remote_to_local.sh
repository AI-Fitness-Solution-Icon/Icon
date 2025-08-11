#!/bin/bash

# ============================
# Clone Remote Supabase to Local
# ============================

# Exit script on first error
set -e

# --- CONFIGURATION ---
PROJECT_REF="rzbzadllidsuexaspxyz" # Replace with your Supabase Project Ref
LOCAL_DB_URL="postgresql://postgres:postgres@localhost:54322/postgres"

# --- STEP 1: Link to remote project ---
echo "🔗 Linking to remote Supabase project: $PROJECT_REF"
supabase link --project-ref $PROJECT_REF

# --- STEP 2: Pull remote migrations ---
echo "📥 Pulling remote migrations..."
supabase db pull

# --- STEP 3: Dump remote schema + data ---
echo "💾 Dumping remote database schema + data..."
REMOTE_DB_URL=$(supabase db remote-url)

pg_dump \
  --no-owner \
  --no-privileges \
  "$REMOTE_DB_URL" > remote_full_dump.sql

echo "✅ Dump created: remote_full_dump.sql"

# --- STEP 4: Restore into local Supabase ---
echo "📂 Restoring dump into local Supabase..."
psql "$LOCAL_DB_URL" < remote_full_dump.sql

echo "🎉 Local Supabase is now synced with remote!"
