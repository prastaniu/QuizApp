<template>
  <div class="container-fluid my-4">
    <div class="row mb-4">
      <div class="col-12">
        <h2>My Quiz Results</h2>
      </div>
    </div>

    <div v-if="isLoading" class="text-center">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>

    <div v-else-if="results.length === 0" class="alert alert-info">
      You haven't attempted any quizzes yet.
    </div>

    <div v-else class="row">
      <div v-for="result in results" :key="result.id" class="col-md-6 mb-4">
        <div class="card h-100">
          <div class="card-body">
            <h5 class="card-title">{{ result.quiz?.title }}</h5>
            <p class="card-text text-muted">By: {{ result.quiz?.teacher?.user?.name }}</p>

            <div class="mt-3">
              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong>Score:</strong>
                  <span>{{ result.obtained_marks }}/{{ result.quiz?.total_marks }}</span>
                </div>
              </div>

              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong>Percentage:</strong>
                  <span>{{ ((result.obtained_marks / result.quiz?.total_marks) * 100).toFixed(2) }}%</span>
                </div>
              </div>

              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong>Status:</strong>
                  <span>
                    <span v-if="(result.obtained_marks / result.quiz?.total_marks * 100) >= result.quiz?.passing_percentage" class="badge bg-success">Passed</span>
                    <span v-else class="badge bg-danger">Failed</span>
                  </span>
                </div>
              </div>

              <small class="text-muted d-block">
                <strong>Submitted:</strong> {{ formatDate(result.end_time) }}
              </small>
            </div>
          </div>
          <div class="card-footer bg-white">
            <button type="button" class="btn btn-sm btn-outline-primary w-100" @click="viewDetails(result.id)">
              View Details
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Details Modal -->
    <div v-if="selectedAttempt" class="modal fade show d-block" style="background-color: rgba(0,0,0,0.5)">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Quiz Attempt Details</h5>
            <button type="button" class="btn-close" @click="selectedAttempt = null"></button>
          </div>
          <div class="modal-body">
            <div v-if="selectedAttempt" class="mb-4">
              <h6 class="mb-3">{{ selectedAttempt.quiz?.title }}</h6>
              <div class="row mb-4">
                <div class="col-md-3">
                  <small class="text-muted">Score</small>
                  <p class="fw-bold">{{ selectedAttempt.obtained_marks }}/{{ selectedAttempt.quiz?.total_marks }}</p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Percentage</small>
                  <p class="fw-bold">{{ ((selectedAttempt.obtained_marks / selectedAttempt.quiz?.total_marks) * 100).toFixed(2) }}%</p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Status</small>
                  <p>
                    <span v-if="(selectedAttempt.obtained_marks / selectedAttempt.quiz?.total_marks * 100) >= selectedAttempt.quiz?.passing_percentage" class="badge bg-success">Passed</span>
                    <span v-else class="badge bg-danger">Failed</span>
                  </p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Submitted</small>
                  <p>{{ formatDate(selectedAttempt.end_time) }}</p>
                </div>
              </div>

              <hr />

              <h6 class="mb-3">Your Answers</h6>
              <div v-for="(question, index) in sortedQuestions" :key="question.id" class="mb-4 p-3 border rounded">
                <div class="mb-2">
                  <strong>Q{{ index + 1 }}. {{ question.question_text }}</strong>
                </div>
                <small class="text-muted d-block mb-2" v-if="getAnswerForQuestion(question.id)">
                  Marks: {{ getAnswerForQuestion(question.id).marks_obtained }}/{{ question.marks }}
                  <span v-if="getAnswerForQuestion(question.id).is_correct" class="badge bg-success ms-2">Correct</span>
                  <span v-else class="badge bg-danger ms-2">Incorrect</span>
                </small>
                <small class="text-muted d-block mb-2" v-else>
                  Marks: 0/{{ question.marks }}
                  <span class="badge bg-warning ms-2">Not answered</span>
                </small>
                <div>
                  <small><strong>Your answer:</strong></small><br />
                  <small v-if="getAnswerForQuestion(question.id)">
                    {{ getAnswerForQuestion(question.id).answer_text || question.options?.find(o => o.id === getAnswerForQuestion(question.id).selected_option_id)?.option_text || getAnswerForQuestion(question.id).selected_option?.option_text || 'Not answered' }}
                  </small>
                  <small v-else class="text-muted">Not answered</small>
                </div>
                <div class="mt-2">
                  <small><strong>Correct Answer:</strong></small><br />
                  <small class="text-success">{{ getCorrectAnswer(question) || 'N/A' }}</small>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="selectedAttempt = null">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { studentService } from '../../services/authService'

const router = useRouter()
const results = ref([])
const isLoading = ref(false)
const selectedAttempt = ref(null)

onMounted(async () => {
  await fetchResults()
})

const fetchResults = async () => {
  isLoading.value = true
  try {
    const response = await studentService.getResults()
    results.value = response.data.results
  } catch (error) {
    console.error('Failed to fetch results:', error)
  } finally {
    isLoading.value = false
  }
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString()
}

const sortedAnswers = computed(() => {
  if (!selectedAttempt.value?.answers) return []
  return [...selectedAttempt.value.answers].sort((a, b) => {
    const aOrder = a.question?.order !== null && a.question?.order !== undefined ? a.question.order : a.question_id
    const bOrder = b.question?.order !== null && b.question?.order !== undefined ? b.question.order : b.question_id
    return aOrder - bOrder
  })
})

const sortedQuestions = computed(() => {
  if (!selectedAttempt.value?.quiz?.questions) return []
  return [...selectedAttempt.value.quiz.questions].sort((a, b) => {
    const aOrder = a.order ?? a.id
    const bOrder = b.order ?? b.id
    return aOrder - bOrder
  })
})

const getAnswerForQuestion = (questionId) => {
  return selectedAttempt.value?.answers?.find(answer => answer.question_id === questionId)
}

const getCorrectAnswer = (question) => {
  if (question.question_type === 'multiple_choice') {
    return question.options?.find(option => option.is_correct)?.option_text
  }
  // For other types, might need to handle differently, but assuming multiple choice for now
  return question.correct_answer
}

const viewDetails = async (attemptId) => {
  try {
    const response = await studentService.getAttemptDetails(attemptId)
    selectedAttempt.value = response.data.attempt
  } catch (error) {
    console.error('Failed to fetch attempt details:', error)
    alert('Failed to load attempt details')
  }
}
</script>
