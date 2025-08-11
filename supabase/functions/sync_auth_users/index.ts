// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Create a Supabase client using the service role key
const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

console.log("sync_auth_users function is running...");

Deno.serve(async (req) => {
  try {
    const { record } = await req.json();

    const { id, email } = record;

    if (!id) {
      return new Response("No user data in payload", { status: 400 });
    }

    // Insert into public.users
    const { error } = await supabase
      .from("users")
      .insert([
        {
          id,
          email,
          'first_name': email ? email.split("@")[0] : null,
          'last_name': "",
          'role_id': '40b641b8-ff16-49fb-a68b-37b0c405c01f',
          'created_at': new Date().toISOString(),
        },
      ]);

    if (error) {
      console.error("DB insert error:", error);
      return new Response("Database insert failed", { status: 500 });
    }

    return new Response(JSON.stringify({ message: "User synced" }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err) {
    console.error("Function error:", err);
    return new Response("Server error", { status: 500 });
  }
});