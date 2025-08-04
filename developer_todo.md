# Developer TODO - Manual Tasks

This file contains tasks that require manual intervention and cannot be automated by the AI assistant.

## API Keys and Configuration

### Environment Variables Setup
- [ ] **Stripe API Keys**: Add Stripe publishable and secret keys to `.env` file
  - Get keys from Stripe Dashboard: https://dashboard.stripe.com/apikeys
  - Add `STRIPE_PUBLISHABLE_KEY` and `STRIPE_SECRET_KEY` to `.env`
  - Never commit these keys to version control

- [ ] **Supabase Configuration**: Add Supabase URL and anon key to `.env` file
  - Get keys from Supabase Dashboard: https://app.supabase.com/project/_/settings/api
  - Add `SUPABASE_URL` and `SUPABASE_ANON_KEY` to `.env`

- [ ] **OpenAI API Key**: Add OpenAI API key for AI coach functionality
  - Get key from OpenAI Dashboard: https://platform.openai.com/api-keys
  - Add `OPENAI_API_KEY` to `.env` file

### Database Setup
- [ ] **Supabase Database**: Set up Supabase project and database
  - Create new project at https://app.supabase.com
  - Run the updated schema.sql file to create all necessary tables including trainer_profiles
  - Configure Row Level Security (RLS) policies
  - Set up database triggers and functions

- [ ] **Database Schema Updates**: If any schema changes are needed
  - ✅ Updated `schema.sql` file with trainer_profiles table
  - Apply migrations to production database
  - Update any related model classes

## External Service Configuration

### Stripe Setup
- [ ] **Stripe Webhook Configuration**: Set up webhook endpoints
  - Configure webhook URL in Stripe Dashboard
  - Add webhook secret to environment variables
  - Test webhook functionality

- [ ] **Stripe Product Configuration**: Create subscription products
  - Create subscription plans in Stripe Dashboard
  - Configure pricing tiers and features
  - Set up product metadata

### Supabase Setup
- [ ] **Authentication Configuration**: Configure auth providers
  - Enable email/password authentication
  - Configure social login providers (Google, Apple)
  - Set up password reset functionality
  - Configure email templates

- [ ] **Storage Configuration**: Set up file storage
  - Configure storage buckets for user uploads
  - Set up storage policies
  - Configure image optimization

### OpenAI Setup
- [ ] **OpenAI Model Configuration**: Configure AI models
  - Choose appropriate model for voice interactions
  - Set up conversation context management
  - Configure response formatting

## App Store Configuration

### iOS App Store
- [ ] **App Store Connect Setup**: Configure iOS app
  - Create app in App Store Connect
  - Configure app metadata and screenshots
  - Set up in-app purchases for subscriptions
  - Configure app review information

### Google Play Store
- [ ] **Google Play Console Setup**: Configure Android app
  - Create app in Google Play Console
  - Configure app metadata and screenshots
  - Set up subscription products
  - Configure app review information

## Development Environment

### Local Development
- [ ] **Flutter Environment**: Ensure Flutter is properly set up
  - Install Flutter SDK and dependencies
  - Configure Android Studio / VS Code
  - Set up iOS development environment (macOS only)
  - Configure device testing

- [ ] **Code Signing**: Set up app signing
  - Configure iOS code signing certificates
  - Set up Android keystore for app signing
  - Configure build variants

- [ ] **Disk Space Management**: Resolve disk space issues
  - Clean up disk space (currently at 99% capacity)
  - Remove unnecessary files and build artifacts
  - Consider upgrading storage if needed
  - Set up regular cleanup procedures

## Testing and Deployment

### Testing Setup
- [ ] **Test Device Configuration**: Set up test devices
  - Configure iOS simulator and physical devices
  - Set up Android emulator and physical devices
  - Test on different screen sizes and OS versions

### Deployment
- [ ] **CI/CD Pipeline**: Set up automated deployment
  - Configure GitHub Actions or similar CI/CD
  - Set up automated testing
  - Configure app store deployment

## Security and Compliance

### Security Review
- [ ] **Security Audit**: Review security measures
  - Audit API key management
  - Review data encryption
  - Check for security vulnerabilities
  - Validate privacy compliance

### Privacy Compliance
- [ ] **Privacy Policy**: Create and configure privacy policy
  - Write comprehensive privacy policy
  - Configure privacy policy URL in app
  - Ensure GDPR/CCPA compliance

## Documentation

### User Documentation
- [ ] **User Guide**: Create user documentation
  - Write comprehensive user guide
  - Create onboarding flow documentation
  - Document feature usage

### Developer Documentation
- [ ] **API Documentation**: Document APIs
  - Document all API endpoints
  - Create API usage examples
  - Document error codes and responses

---

## Notes

- Check this file regularly for new tasks
- Update task status as items are completed
- Add new tasks as they are identified
- Provide detailed instructions for each task
- Include relevant links and resources 