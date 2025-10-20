A Flutter application with authentication and a photo gallery.

## 📋 Implemented Features

### ✅ Required Features

1. **Authentication**

   * Login screen with email and password fields
   * Integration with the reqres.in API to simulate login
   * Token storage in `shared_preferences`
   * Automatic navigation to the main screen after login
   * Logout functionality

2. **Image Gallery**

   * Display a photo grid using the picsum.photos API
   * Lazy loading on scroll (pagination by 20 photos)
   * Fullscreen photo preview on tap
   * Pull-to-refresh to reload the list

3. **Add Photo**

   * Button to add a new photo
   * Select image via `image_picker` (camera or gallery)
   * Add the selected photo to the beginning of the list
   * Save locally (not on the server)

4. **Technical Implementation**

   * State management: **Riverpod 2.x**
   * Clean architecture with separated layers
   * Error and loading state handling
   * Responsive UI
