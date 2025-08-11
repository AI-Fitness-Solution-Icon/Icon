drop policy "Allow public read on ai_agents" on "public"."ai_agents";

drop policy "Allow public read on ai_interactions" on "public"."ai_interactions";

drop policy "Allow public read on badges" on "public"."badges";

drop policy "Allow public read on client_badges" on "public"."client_badges";

drop policy "Allow public read on client_progress" on "public"."client_progress";

drop policy "Allow public read on clients" on "public"."clients";

drop policy "Allow public read on coaches" on "public"."coaches";

drop policy "Allow public read on exercises" on "public"."exercises";

drop policy "Allow public read on feedback" on "public"."feedback";

drop policy "Allow public read on gamification" on "public"."gamification";

drop policy "Allow public read on payment_history" on "public"."payment_history";

drop policy "Allow public read on performance_metrics" on "public"."performance_metrics";

drop policy "Allow public read on roles" on "public"."roles";

drop policy "Allow public read on subscription_plans" on "public"."subscription_plans";

drop policy "Allow public read on trainer_profiles" on "public"."trainer_profiles";

drop policy "Allow public read on user_settings" on "public"."user_settings";

drop policy "Allow public read on user_subscriptions" on "public"."user_subscriptions";

drop policy "Allow public read on users" on "public"."users";

drop policy "Allow public read on workout_exercises" on "public"."workout_exercises";

drop policy "Allow public read on workout_sessions" on "public"."workout_sessions";

drop policy "Allow public read on workouts" on "public"."workouts";

create policy "Allow public read on ai_agents"
on "public"."ai_agents"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on ai_interactions"
on "public"."ai_interactions"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on badges"
on "public"."badges"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on client_badges"
on "public"."client_badges"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on client_progress"
on "public"."client_progress"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on clients"
on "public"."clients"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on coaches"
on "public"."coaches"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on exercises"
on "public"."exercises"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on feedback"
on "public"."feedback"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on gamification"
on "public"."gamification"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on payment_history"
on "public"."payment_history"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on performance_metrics"
on "public"."performance_metrics"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on roles"
on "public"."roles"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on subscription_plans"
on "public"."subscription_plans"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on trainer_profiles"
on "public"."trainer_profiles"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on user_settings"
on "public"."user_settings"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on user_subscriptions"
on "public"."user_subscriptions"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on users"
on "public"."users"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on workout_exercises"
on "public"."workout_exercises"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on workout_sessions"
on "public"."workout_sessions"
as permissive
for select
to anon, authenticated
using (true);


create policy "Allow public read on workouts"
on "public"."workouts"
as permissive
for select
to anon, authenticated
using (true);



