<template>
  <div class="container my-5">
    <div class="row">
      <div class="col-md-6 mx-auto">
        <div class="card shadow">
          <div class="card-body p-5">
            <h2 class="text-center mb-4">Login</h2>
            
            <div v-if="error" class="alert alert-danger alert-dismissible fade show" role="alert">
              {{ error }}
              <button type="button" class="btn-close" @click="error = null"></button>
            </div>

            <form @submit.prevent="handleLogin">
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
                <label for="password" class="form-label">Password</label>
                <input
                  id="password"
                  v-model="formData.password"
                  type="password"
                  class="form-control"
                  required
                  placeholder="Enter your password"
                />
              </div>

              <button
                type="submit"
                class="btn btn-primary w-100"
                :disabled="isLoading"
              >
                <span v-if="!isLoading">Login</span>
                <span v-else>
                  <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                  Logging in...
                </span>
              </button>
            </form>

            <p class="text-center mt-3">
              Don't have an account?
              <router-link to="/register" class="text-primary">Register here</router-link>
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
  email: '',
  password: ''
})

const isLoading = ref(false)
const error = ref(null)

onMounted(() => {
  if (authStore.isLoggedIn) {
    router.push('/dashboard')
  }
})

const handleLogin = async () => {
  isLoading.value = true
  error.value = null

  try {
    await authStore.login(formData.email, formData.password)
    router.push('/dashboard')
  } catch (err) {
    error.value = err.response?.data?.message || 'Login failed. Please try again.'
  } finally {
    isLoading.value = false
  }
}
</script>
