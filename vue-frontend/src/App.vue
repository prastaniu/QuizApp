<template>
  <div id="app">
    <AppHeader />
    <main :class="{ 'with-header': authStore.isLoggedIn }">
      <router-view></router-view>
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from './stores/auth'
import { onMounted } from 'vue'
import AppHeader from './components/AppHeader.vue'

const router = useRouter()
const authStore = useAuthStore()

onMounted(() => {
  // Check if user is logged in on app mount
  const token = localStorage.getItem('auth_token')
  if (token) {
    authStore.loadUserProfile()
  }
})
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f5f5f5;
}

html, body, #app {
  height: 100%;
}

main.with-header {
  padding-top: 70px;
  min-height: 100vh;
  background-image: linear-gradient(180deg, #fdfbfb 0%, #ebedee 100%);
}

.card, .btn {
  border-radius: 0.7rem;
}

.table thead {
  background-color: #0d6efd;
  color: white;
}

.badge.bg-success {
  background-color: #28a745;
}

.badge.bg-danger {
  background-color: #dc3545;
}

.navbar {
  background: linear-gradient(90deg, #003b5c, #005682);
}

</style>
