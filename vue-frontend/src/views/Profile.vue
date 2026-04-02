<template>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card shadow-sm">
          <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Edit Profile</h5>
          </div>
          <div class="card-body">
            <form @submit.prevent="updateProfile">
              <div class="mb-3">
                <label class="form-label">Name</label>
                <input v-model="profile.name" type="text" class="form-control" required />
              </div>

              <div class="mb-3">
                <label class="form-label">Email</label>
                <input v-model="profile.email" type="email" class="form-control" required />
              </div>

              <div class="mb-3">
                <label class="form-label">Phone</label>
                <input v-model="profile.phone" type="tel" class="form-control" placeholder="Optional" />
              </div>

              <hr />

              <h6 class="mb-3">Change Password</h6>

              <div class="mb-3">
                <label class="form-label">Current Password</label>
                <input v-model="passwordData.current_password" type="password" class="form-control" />
              </div>

              <div class="mb-3">
                <label class="form-label">New Password</label>
                <input v-model="passwordData.new_password" type="password" class="form-control" />
              </div>

              <div class="mb-3">
                <label class="form-label">Confirm New Password</label>
                <input v-model="passwordData.confirm_password" type="password" class="form-control" />
              </div>

              <div class="alert alert-info small" v-if="passwordData.new_password">
                Password must be at least 8 characters long
              </div>

              <button type="submit" class="btn btn-primary w-100" :disabled="isSaving">
                <span v-if="isSaving"><i class="spinner-border spinner-border-sm me-2"></i>Saving...</span>
                <span v-else>Save Changes</span>
              </button>
            </form>

            <div v-if="successMessage" class="alert alert-success mt-3 mb-0">
              {{ successMessage }}
            </div>

            <div v-if="errorMessage" class="alert alert-danger mt-3 mb-0">
              {{ errorMessage }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const profile = reactive({
  name: '',
  email: '',
  phone: ''
})

const passwordData = reactive({
  current_password: '',
  new_password: '',
  confirm_password: ''
})

const isSaving = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

onMounted(() => {
  // Use the user from auth store instead of fetching
  if (authStore.user) {
    profile.name = authStore.user.name
    profile.email = authStore.user.email
    profile.phone = authStore.user.phone || ''
  }
})

const updateProfile = async () => {
  errorMessage.value = ''
  successMessage.value = ''

  // Validate password if provided
  if (passwordData.new_password || passwordData.current_password) {
    if (!passwordData.current_password) {
      errorMessage.value = 'Current password is required to change password'
      return
    }
    if (passwordData.new_password.length < 8) {
      errorMessage.value = 'New password must be at least 8 characters long'
      return
    }
    if (passwordData.new_password !== passwordData.confirm_password) {
      errorMessage.value = 'Passwords do not match'
      return
    }
  }

  isSaving.value = true
  try {
    const updateData = {
      name: profile.name,
      email: profile.email,
      phone: profile.phone
    }

    if (passwordData.new_password) {
      updateData.current_password = passwordData.current_password
      updateData.password = passwordData.new_password
      updateData.password_confirmation = passwordData.confirm_password
    }

    await authService.updateProfile(updateData)
    successMessage.value = 'Profile updated successfully'

    // Update the auth store user
    authStore.user.name = profile.name
    authStore.user.email = profile.email
    authStore.user.phone = profile.phone

    // Clear password fields
    passwordData.current_password = ''
    passwordData.new_password = ''
    passwordData.confirm_password = ''

    // Reset message after 3 seconds
    setTimeout(() => {
      successMessage.value = ''
    }, 3000)
  } catch (error) {
    console.error('Failed to update profile:', error)
    if (error.response?.data?.message) {
      errorMessage.value = error.response.data.message
    } else {
      errorMessage.value = 'Failed to update profile'
    }
  } finally {
    isSaving.value = false
  }
}
</script>
