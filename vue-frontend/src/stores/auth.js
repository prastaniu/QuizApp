import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authService } from '../services/authService'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('auth_token') || null)
  const isLoading = ref(false)
  const error = ref(null)

  const isLoggedIn = computed(() => !!token.value && !!user.value)
  const isTeacher = computed(() => user.value?.role === 'teacher')
  const isStudent = computed(() => user.value?.role === 'student')

  const register = async (formData) => {
    isLoading.value = true
    error.value = null
    try {
      const response = await authService.register(formData)
      console.log(response)
      token.value = response.data.access_token
      user.value = response.data.user
      localStorage.setItem('auth_token', token.value)
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Registration failed'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  const login = async (email, password) => {
    isLoading.value = true
    error.value = null
    try {
      const response = await authService.login(email, password)
      token.value = response.data.access_token
      user.value = response.data.user
      localStorage.setItem('auth_token', token.value)
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Login failed'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  const loadUserProfile = async () => {
    if (!token.value) return
    isLoading.value = true
    try {
      const response = await authService.getProfile()
      user.value = response.data.user
    } catch (err) {
      error.value = 'Failed to load profile'
      logout()
    } finally {
      isLoading.value = false
    }
  }

  const logout = async () => {
    isLoading.value = true
    try {
      await authService.logout()
    } catch (err) {
      console.error('Logout error:', err)
    } finally {
      user.value = null
      token.value = null
      localStorage.removeItem('auth_token')
      isLoading.value = false
    }
  }

  return {
    user,
    token,
    isLoading,
    error,
    isLoggedIn,
    isTeacher,
    isStudent,
    register,
    login,
    logout,
    loadUserProfile
  }
})
