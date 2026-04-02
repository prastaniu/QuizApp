<template>
  <div class="container-fluid my-4">
    <div class="row mb-4">
      <div class="col-12">
        <h2>{{ quiz?.title }}</h2>
        <p class="text-muted">{{ quiz?.description }}</p>
      </div>
    </div>

    <div v-if="isLoading" class="text-center">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>

    <div v-else-if="quiz && currentAttempt" class="row">
      <div v-if="isSubmitted" class="col-12">
        <div class="alert alert-success text-center">
          <h4>Quiz Submitted Successfully!</h4>
          <p>You will be redirected to the dashboard shortly...</p>
        </div>
      </div>
      
      <div v-else class="col-lg-8">
        <div class="card">
          <div class="card-header bg-primary text-white">
            <div class="d-flex justify-content-between align-items-center">
              <span>Question {{ currentQuestionIndex + 1 }} of {{ quiz.questions.length }}</span>
              <span>Time: {{ timeRemaining }}</span>
            </div>
          </div>
          <div class="card-body">
            <h5 class="mb-4">{{ currentQuestion.question_text }}</h5>

            <div v-if="currentQuestion.question_type === 'multiple_choice'">
              <div v-for="option in currentQuestion.options" :key="option.id" class="form-check mb-3">
                <input
                  :id="`option-${option.id}`"
                  type="radio"
                  :name="`question-${currentQuestion.id}`"
                  :value="option.id"
                  v-model.number="selectedAnswer"
                  class="form-check-input"
                  :disabled="isSubmitted"
                />
                <label :for="`option-${option.id}`" class="form-check-label">
                  {{ option.option_text }}
                </label>
              </div>
            </div>

            <div v-else-if="currentQuestion.question_type === 'true_false'" class="mt-4">
              <div class="form-check">
                <input
                  id="true-option"
                  type="radio"
                  value="true"
                  v-model="selectedAnswer"
                  class="form-check-input"
                  :disabled="isSubmitted"
                />
                <label for="true-option" class="form-check-label">
                  True
                </label>
              </div>
              <div class="form-check">
                <input
                  id="false-option"
                  type="radio"
                  value="false"
                  v-model="selectedAnswer"
                  class="form-check-input"
                  :disabled="isSubmitted"
                />
                <label for="false-option" class="form-check-label">
                  False
                </label>
              </div>
            </div>

            <div v-else-if="currentQuestion.question_type === 'short_answer'" class="mt-4">
              <textarea
                v-model="selectedAnswer"
                class="form-control"
                rows="4"
                placeholder="Enter your answer here..."
                :disabled="isSubmitted"
              ></textarea>
            </div>
          </div>
          <div class="card-footer bg-light">
            <div class="d-flex justify-content-md-end">
              <button
                type="button"
                class="btn btn-outline-secondary"
                @click="previousQuestion"
                :disabled="currentQuestionIndex === 0 || isSubmitted"
              >
                ← Previous
              </button>

              <!-- <button
                type="button"
                class="btn btn-primary"
                @click="saveAnswer"
                :disabled="isSubmitted"
              >
                Save Answer
              </button> -->

              <button
                v-if="currentQuestionIndex < quiz.questions.length - 1"
                type="button"
                class="btn btn-outline-secondary"
                @click="nextQuestion"
                :disabled="isSubmitted"
              >
                Next →
              </button>
              <button
                v-else
                type="button"
                class="btn btn-success"
                @click="submitQuiz"
                :disabled="isSubmitted"
              >
                Submit Quiz
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="card">
          <div class="card-header">
            <h5 class="mb-0">Question Navigator</h5>
          </div>
          <div class="card-body">
            <div class="btn-group-vertical w-100" role="group">
              <button
                v-for="(q, index) in quiz.questions"
                :key="q.id"
                type="button"
                class="btn text-start"
                :class="[
                  'btn-outline-primary',
                  currentQuestionIndex === index ? 'active' : '',
                  isAnswered(q.id) ? 'btn-success' : ''
                ]"
                @click="currentQuestionIndex = index"
                :disabled="isSubmitted"
              >
                Q{{ index + 1 }}
                <span v-if="isAnswered(q.id)" class="float-end">✓</span>
              </button>
            </div>
          </div>
        </div>

        <div class="card mt-3">
          <div class="card-body">
            <h6>Quiz Info</h6>
            <small class="text-muted d-block">
              <strong>Duration:</strong> {{ quiz.duration }} minutes
            </small>
            <small class="text-muted d-block">
              <strong>Total Marks:</strong> {{ quiz.total_marks }}
            </small>
            <small class="text-muted d-block">
              <strong>Passing:</strong> {{ quiz.passing_percentage }}%
            </small>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="alert alert-danger">
      Unable to load quiz. Please try again.
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { studentService } from '../../services/authService'

const route = useRoute()
const router = useRouter()
const quiz = ref(null)
const currentAttempt = ref(null)
const isLoading = ref(false)
const currentQuestionIndex = ref(0)
const selectedAnswer = ref(null)
const answeredQuestions = ref({})
const timeRemaining = ref('')
const isSubmitted = ref(false)

onMounted(async () => {
  await loadQuiz()
  // Only start timer after quiz is fully loaded
  if (quiz.value && quiz.value.duration && currentAttempt.value) {
    startTimer()
  } else {
    console.error('Quiz not properly loaded, timer not started')
  }
})

const loadQuiz = async () => {
  isLoading.value = true
  try {
    const response = await studentService.getQuiz(route.params.id)
    quiz.value = response.data.quiz
    
    // Start quiz attempt
    const attemptResponse = await studentService.startQuiz(route.params.id)
    currentAttempt.value = attemptResponse.data.attempt
    
    // Use duration from attempt response as fallback
    if (attemptResponse.data.quiz_duration && !quiz.value.duration) {
      quiz.value.duration = attemptResponse.data.quiz_duration
    }
  } catch (error) {
    console.error('Failed to load quiz:', error)
  } finally {
    isLoading.value = false
  }
}

const currentQuestion = computed(() => {
  return quiz.value?.questions[currentQuestionIndex.value] || {}
})

const nextQuestion = () => {
  if (currentQuestionIndex.value < quiz.value.questions.length - 1) {
    saveAnswer()
    currentQuestionIndex.value++
    loadAnswerForCurrentQuestion()
  }
}

const previousQuestion = () => {
  if (currentQuestionIndex.value > 0) {
    saveAnswer()
    currentQuestionIndex.value--
    loadAnswerForCurrentQuestion()
  }
}

const saveAnswer = async () => {
  if (!selectedAnswer.value) return
  
  try {
    await studentService.submitAnswer({
      quiz_attempt_id: currentAttempt.value.id,
      question_id: currentQuestion.value.id,
      selected_option_id: currentQuestion.value.question_type === 'multiple_choice' ? selectedAnswer.value : null,
      answer_text: ['true_false', 'short_answer'].includes(currentQuestion.value.question_type) ? selectedAnswer.value : null
    })
    
    answeredQuestions.value[currentQuestion.value.id] = true
  } catch (error) {
    console.error('Failed to save answer:', error)
  }
}

const loadAnswerForCurrentQuestion = () => {
  const attempt = currentAttempt.value
  const qId = currentQuestion.value.id
  const answer = attempt.answers?.find(a => a.question_id === qId)
  selectedAnswer.value = answer ? answer.selected_option_id || answer.answer_text : null
}

const isAnswered = (questionId) => {
  return !!answeredQuestions.value[questionId]
}

const submitQuiz = async (autoSubmit = false) => {
  if (isSubmitted.value) return // Prevent multiple submissions
  
  if (!autoSubmit && !confirm('Are you sure you want to submit the quiz? You cannot change your answers after submission.')) {
    return
  }
  
  try {
    // Save the current answer before submitting
    await saveAnswer()
    
    const response = await studentService.submitQuiz(currentAttempt.value.id)
    const result = response.data
    isSubmitted.value = true
    
    if (autoSubmit) {
      alert(`Time's up! Quiz auto-submitted.\nYour score: ${result.percentage.toFixed(2)}%\nResult: ${result.passed ? 'PASSED' : 'FAILED'}`)
    } else {
      alert(`Quiz submitted! Your score: ${result.percentage.toFixed(2)}%\nResult: ${result.passed ? 'PASSED' : 'FAILED'}`)
    }
    
    // Redirect to student results page after a short delay
    setTimeout(() => {
      router.push('/student/results')
    }, 2000)
  } catch (error) {
    console.error('Failed to submit quiz:', error)
    if (!autoSubmit) {
      alert('Error submitting quiz')
    }
  }
}

const startTimer = () => {
  const interval = setInterval(() => {
    if (isSubmitted.value) {
      clearInterval(interval)
      return
    }
    
    if (quiz.value && currentAttempt.value) {
      // Validate and set default quiz duration if invalid
      let duration = quiz.value.duration
      if (!duration || duration <= 0) {
        console.warn('Invalid quiz duration:', duration, '- using default 30 minutes')
        duration = 30 // Default to 30 minutes
        quiz.value.duration = duration
      }

      try {
        const startTime = new Date(currentAttempt.value.start_time)
        const now = new Date()
        
        // Validate startTime parsing
        if (isNaN(startTime.getTime())) {
          console.error('Invalid start_time:', currentAttempt.value.start_time)
          clearInterval(interval)
          return
        }
        
        const elapsedSeconds = Math.floor((now - startTime) / 1000)
        console.log('Timer debug - Duration:', duration, 'Elapsed:', elapsedSeconds, 'Start time:', startTime.toISOString())
        
        // Prevent negative elapsed time (clock skew tolerance: -30 seconds)
        if (elapsedSeconds < -30) {
          console.warn('Clock skew detected, elapsed:', elapsedSeconds, '- waiting...')
          return
        }
        
        const totalSeconds = duration * 60
        const remainingSeconds = Math.max(0, totalSeconds - Math.max(0, elapsedSeconds))
        
        const minutes = Math.floor(remainingSeconds / 60)
        const seconds = remainingSeconds % 60
        timeRemaining.value = `${minutes}:${seconds.toString().padStart(2, '0')}`
        
        if (remainingSeconds <= 0) {
          console.log('Time up - auto-submitting quiz')
          clearInterval(interval)
          submitQuiz(true)
        }
      } catch (error) {
        console.error('Timer calculation error:', error)
        clearInterval(interval)
      }
    }
  }, 1000)
}
</script>
