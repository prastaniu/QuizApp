<template>
  <div class="d-flex" style="min-height: 100vh;">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark w-100" style="position: fixed; top: 0; width: 100%; z-index: 1000;">
      <div class="container-fluid">
        <router-link to="/dashboard" class="navbar-brand fw-bold">QuizApp</router-link>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav"  v-show="authStore.isAuthenticated">
          <ul class="navbar-nav ms-auto">
            <li v-if="authStore.isTeacher" class="nav-item">
              <router-link to="/teacher/quizzes" class="nav-link">My Quizzes</router-link>
            </li>
            <li v-if="authStore.isStudent" class="nav-item">
              <router-link to="/student/quizzes" class="nav-link">Available Quizzes</router-link>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                {{ authStore.user?.name }}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" @click="logout" href="#">Logout</a></li>
                <li><router-link to="/profile" class="dropdown-item">Profile</router-link></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container-fluid pt-5 mt-5">
  <div class="row">
    <div class="col-12 text-center text-md-start">
      <h1 class="fw-bold">Dashboard</h1>
      <p class="text-muted">
        Welcome, {{ authStore.user?.name }}! ({{ authStore.user?.role }})
      </p>
    </div>
  </div>

  <!-- Teacher Cards -->
  <div v-if="authStore.isTeacher" class="row mt-4">
    <div class="col-md-6 mb-3">
      <div class="card h-100 shadow-sm">
        <div class="card-body">
          <h5 class="card-title">My Quizzes</h5>
          <p class="card-text">Create and manage your quizzes</p>
          <router-link to="/teacher/quizzes" class="btn btn-primary">View Quizzes</router-link>
        </div>
      </div>
    </div>
  </div>

  <!-- Student Cards -->
  <div v-if="authStore.isStudent" class="row mt-4">
    <div class="col-md-6 mb-3">
      <div class="card h-100 shadow-sm">
        <div class="card-body">
          <h5 class="card-title">Available Quizzes</h5>
          <p class="card-text">Take quizzes and test your knowledge</p>
          <router-link to="/student/quizzes" class="btn btn-primary">View Quizzes</router-link>
        </div>
      </div>
    </div>

    <div class="col-md-6 mb-3">
      <div class="card h-100 shadow-sm">
        <div class="card-body">
          <h5 class="card-title">My Results</h5>
          <p class="card-text">View your quiz results</p>
          <router-link to="/student/results" class="btn btn-primary">View Results</router-link>
        </div>
      </div>
    </div>
  </div>
</div>
  </div>
</template>

<script setup>
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()

const logout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script>
