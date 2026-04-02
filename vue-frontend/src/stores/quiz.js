import { defineStore } from 'pinia'
import { ref } from 'vue'
import { teacherService, studentService } from '../services/authService'

export const useQuizStore = defineStore('quiz', () => {
  const quizzes = ref([])
  const currentQuiz = ref(null)
  const isLoading = ref(false)
  const error = ref(null)

  const fetchTeacherQuizzes = async () => {
    isLoading.value = true
    try {
      const response = await teacherService.getQuizzes()
      quizzes.value = response.data.quizzes
    } catch (err) {
      error.value = err.message
    } finally {
      isLoading.value = false
    }
  }

  const fetchStudentQuizzes = async () => {
    isLoading.value = true
    try {
      const response = await studentService.getAvailableQuizzes()
      quizzes.value = response.data.quizzes
    } catch (err) {
      error.value = err.message
    } finally {
      isLoading.value = false
    }
  }

  return {
    quizzes,
    currentQuiz,
    isLoading,
    error,
    fetchTeacherQuizzes,
    fetchStudentQuizzes
  }
})
