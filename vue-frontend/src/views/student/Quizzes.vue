<template>
  <div class="container-fluid my-4">
    <div class="row mb-4">
      <div class="col-12">
        <h2>Available Quizzes</h2>
      </div>
    </div>

    <div v-if="isLoading" class="text-center">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>

    <div v-else-if="quizzes.length === 0" class="alert alert-info">
      No quizzes available at the moment.
    </div>

    <div v-else class="row">
      <div v-for="quiz in quizzes" :key="quiz.id" class="col-md-6 mb-4">
        <div class="card h-100">
          <div class="card-body">
            <h5 class="card-title">{{ quiz.title }}</h5>
            <p class="card-text small">{{ quiz.description }}</p>
            
            <div class="mt-3 mb-3">
              <small class="text-muted d-block">
                <strong>Duration:</strong> {{ quiz.duration }} minutes
              </small>
              <small class="text-muted d-block">
                <strong>Total Marks:</strong> {{ quiz.total_marks }}
              </small>
              <small class="text-muted d-block">
                <strong>Questions:</strong> {{ quiz.questions?.length || 0 }}
              </small>
              <small class="text-muted d-block">
                <strong>Passing %:</strong> {{ quiz.passing_percentage }}%
              </small>
            </div>

            <div v-if="getAttemptStatus(quiz.id)" class="alert alert-success mb-3">
              {{ getAttemptStatus(quiz.id) }}
            </div>
          </div>
          <div class="card-footer bg-white">
            <button 
              type="button" 
              class="btn btn-primary w-100"
              @click="startQuiz(quiz.id)"
              :disabled="isQuizSubmitted(quiz.id)"
            >
              {{ isQuizSubmitted(quiz.id) ? 'Already Attempted' : 'Start Quiz' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { studentService } from '../../services/authService'

const router = useRouter()
const quizzes = ref([])
const isLoading = ref(false)

onMounted(async () => {
  await fetchQuizzes()
})

const fetchQuizzes = async () => {
  isLoading.value = true
  try {
    const response = await studentService.getAvailableQuizzes()
    quizzes.value = response.data.quizzes
  } catch (error) {
    console.error('Failed to fetch quizzes:', error)
  } finally {
    isLoading.value = false
  }
}

const startQuiz = async (quizId) => {
  try {
    await studentService.startQuiz(quizId)
    router.push(`/student/quizzes/${quizId}`)
  } catch (error) {
    console.error('Failed to start quiz:', error)
    alert('Error starting quiz. You may have already attempted this quiz.')
  }
}

const isQuizSubmitted = (quizId) => {
  // This would be better managed with a store or by checking actual data
  // For now, a simple check
  return false
}

const getAttemptStatus = (quizId) => {
  // In a real app, check if quiz is already attempted
  return null
}
</script>
