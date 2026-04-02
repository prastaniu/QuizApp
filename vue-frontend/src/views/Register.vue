<template>
  <div class="container my-5">
    <div class="row">
      <div class="col-md-8 mx-auto">
        <div class="card shadow">
          <div class="card-body p-5">
            <h2 class="text-center mb-4">Create Account</h2>
            
            <div v-if="error" class="alert alert-danger alert-dismissible fade show" role="alert">
              {{ error }}
              <button type="button" class="btn-close" @click="error = null"></button>
            </div>

            <form @submit.prevent="handleRegister">
              <div class="mb-3">
                <label for="name" class="form-label">Full Name</label>
                <input
                  id="name"
                  v-model="formData.name"
                  type="text"
                  class="form-control"
                  required
                  placeholder="John Doe"
                />
              </div>

              <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input
                  id="email"
                  v-model="formData.email"
                  type="email"
                  class="form-control"
                  required
                  placeholder="your@email.com"
                />
              </div>

              <div class="mb-3">
                <label for="phone" class="form-label">Phone (Optional)</label>
                <input
                  id="phone"
                  v-model="formData.phone"
                  type="tel"
                  class="form-control"
                  placeholder="+1 (555) 000-0000"
                />
              </div>

              <div class="mb-3">
                <label for="role" class="form-label">Role</label>
                <select id="role" v-model="formData.role" class="form-select" required>
                  <option value="">Select a role</option>
                  <option value="teacher">Teacher</option>
                  <option value="student">Student</option>
                </select>
              </div>

              <!-- <div v-if="formData.role === 'teacher'" class="mb-3">
                <label for="department" class="form-label">Department (Optional)</label>
                <input
                  id="department"
                  v-model="formData.department"
                  type="text"
                  class="form-control"
                  placeholder="e.g., Computer Science"
                />
              </div> -->

              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input
                  id="password"
                  v-model="formData.password"
                  type="password"
                  class="form-control"
                  required
                  placeholder="Minimum 8 characters"
                  minlength="8"
                />
              </div>

              <div class="mb-4">
                <label for="password_confirmation" class="form-label">Confirm Password</label>
                <input
                  id="password_confirmation"
                  v-model="formData.password_confirmation"
                  type="password"
                  class="form-control"
                  required
                  placeholder="Confirm password"
                  minlength="8"
                />
              </div>

              <button
                type="submit"
                class="btn btn-primary w-100"
                :disabled="isLoading"
              >
                <span v-if="!isLoading">Create Account</span>
                <span v-else>
                  <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                  Creating...
                </span>
              </button>
            </form>

            <p class="text-center mt-3">
              Already have an account?
              <router-link to="/login" class="text-primary">Login here</router-link>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const formData = reactive({
  name: '',
  email: '',
  phone: '',
  role: '',
  department: '',
  password: '',
  password_confirmation: ''
})

const isLoading = ref(false)
const error = ref(null)

onMounted(() => {
  if (authStore.isLoggedIn) {
    router.push('/dashboard')
  }
})

const handleRegister = async () => {
  if (formData.password !== formData.password_confirmation) {
    error.value = 'Passwords do not match'
    return
  }

  isLoading.value = true
  error.value = null

  try {
    await authStore.register(formData)
    router.push('/dashboard')
  } catch (err) {
    error.value = err.response?.data?.message || 'Registration failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}
</script>
