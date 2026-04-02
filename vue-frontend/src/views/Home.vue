<template>
  <div class="container my-5">
    <div class="row">
      <div class="col-md-8 mx-auto">
        <div class="card shadow">
          <div class="card-body p-5">
            <h1 class="text-center mb-4">Welcome to Quiz App</h1>
            <!-- <p class="text-center text-muted mb-4">
              A comprehensive online quiz system for teachers and students
            </p>
             -->
            <div class="row mt-5">
              <div class="col-md-6 mb-3">
                <div class="card text-center border-primary">
                  <div class="card-body">
                    <h5 class="card-title">Teacher?</h5>
                    <p class="card-text">Create and manage quizzes for your classes</p>
                    <router-link to="/login" class="btn btn-primary">Login as Teacher</router-link>
                  </div>
                </div>
              </div>
              <div class="col-md-6 mb-3">
                <div class="card text-center border-success">
                  <div class="card-body">
                    <h5 class="card-title">Student?</h5>
                    <p class="card-text">Take quizzes and view your results</p>
                    <router-link to="/login" class="btn btn-success">Login as Student</router-link>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="text-center mt-4">
              <p class="text-muted">Don't have an account?</p>
              <router-link to="/register" class="btn btn-outline-primary">Create Account</router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()

if (authStore.isLoggedIn) {
  router.push('/dashboard')
}
</script>
