import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('../views/Profile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/teacher',
    meta: { requiresAuth: true, requiresRole: 'teacher' },
    children: [
      {
        path: 'quizzes',
        name: 'TeacherQuizzes',
        component: () => import('../views/teacher/Quizzes.vue')
      },
      {
        path: 'quizzes/create',
        name: 'CreateQuiz',
        component: () => import('../views/teacher/CreateQuiz.vue')
      },
      {
        path: 'quizzes/:id',
        name: 'EditQuiz',
        component: () => import('../views/teacher/EditQuiz.vue')
      },
      {
        path: 'quizzes/:id/results',
        name: 'QuizResults',
        component: () => import('../views/teacher/QuizResults.vue')
      },
      {
        path: 'reports',
        name: 'Reports',
        component: () => import('../views/teacher/Reports.vue')
      }
    ]
  },
  {
    path: '/student',
    meta: { requiresAuth: true, requiresRole: 'student' },
    children: [
      {
        path: 'quizzes',
        name: 'StudentQuizzes',
        component: () => import('../views/student/Quizzes.vue')
      },
      {
        path: 'quizzes/:id',
        name: 'AttemptQuiz',
        component: () => import('../views/student/AttemptQuiz.vue')
      },
      {
        path: 'results',
        name: 'StudentResults',
        component: () => import('../views/student/Results.vue')
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('../views/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()


  if (to.path === '/login' && authStore.isLoggedIn) {
    next('/dashboard')
  } else if (to.path === '/register' && authStore.isLoggedIn) {
    next('/dashboard')
  } else if (to.meta.requiresAuth && !authStore.isLoggedIn) {
    next('/login')
  } else if (to.meta.requiresRole && authStore.user?.role !== to.meta.requiresRole) {
    next('/dashboard')
  } else {
    next()
  }
})


export default router
