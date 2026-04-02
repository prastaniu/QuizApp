<template>
  <nav v-if="authStore.isLoggedIn && !isAuthPage" class="navbar navbar-expand-lg navbar-dark bg-dark" style="position: fixed; top: 0; width: 100%; z-index: 1000;">
    <div class="container-fluid">
      <router-link to="/dashboard" class="navbar-brand fw-bold">QuizApp</router-link>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li v-if="authStore.isTeacher" class="nav-item">
            <router-link to="/teacher/quizzes" class="nav-link">My Quizzes</router-link>
          </li>
          <li v-if="authStore.isStudent" class="nav-item">
            <router-link to="/student/quizzes" class="nav-link">Available Quizzes</router-link>
          </li>
          <li v-if="authStore.isStudent" class="nav-item">
            <router-link to="/student/results" class="nav-link">My Results</router-link>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
              {{ authStore.user?.name }}
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
              <li><router-link class="dropdown-item" to="/profile">Profile</router-link></li>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" @click="logout" href="#">Logout</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useAuthStore } from '../stores/auth'
import { useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const isAuthPage = computed(() => ['/login', '/register'].includes(route.path))

const logout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.navbar {
  box-shadow: 0 2px 4px rgba(0,0,0,.1);
}
</style>