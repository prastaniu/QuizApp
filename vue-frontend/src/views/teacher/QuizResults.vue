<template>
  <div class="container-fluid my-4">
    <div class="row mb-4">
      <div class="col-12">
        <h2>Quiz Results</h2>
        <p class="text-muted" v-if="quiz">{{ quiz.title }} - {{ quiz.course?.name }}</p>
      </div>
    </div>

    <div v-if="isLoading" class="text-center">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>

    <div v-else-if="attempts.length === 0" class="alert alert-info">
      No attempts yet for this quiz.
    </div>

    <div v-else class="table-responsive">
      <table class="table table-hover">
        <thead class="table-primary">
          <tr>
            <th>Student Name</th>
            <th>Student Email</th>
            <th>Obtained Marks</th>
            <th>Percentage</th>
            <th>Status</th>
            <th>Submitted</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="attempt in attempts" :key="attempt.id">
            <td>{{ attempt.student?.user?.name }}</td>
            <td>{{ attempt.student?.user?.email }}</td>
            <td>{{ attempt.obtained_marks }}/{{ quiz.total_marks }}</td>
            <td>{{ ((attempt.obtained_marks / quiz.total_marks) * 100).toFixed(2) }}%</td>
            <td>
              <span v-if="(attempt.obtained_marks / quiz.total_marks * 100) >= quiz.passing_percentage" class="badge bg-success">Passed</span>
              <span v-else class="badge bg-danger">Failed</span>
            </td>
            <td>{{ formatDate(attempt.end_time) }}</td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-primary me-2" @click="viewResults(attempt.id)">
                View
              </button>
              <button
                type="button"
                class="btn btn-sm btn-outline-warning"
                @click="retakeAttempt(attempt.id)"
              >
                Retake
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Details Modal -->
    <div v-if="selectedAttempt" class="modal fade show d-block" style="background-color: rgba(0,0,0,0.5)">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Student Attempt Details</h5>
            <button type="button" class="btn-close" @click="selectedAttempt = null"></button>
          </div>
          <div class="modal-body">
            <div v-if="selectedAttempt" class="mb-4">
              <div class="mb-3">
                <h6>{{ selectedAttempt.student?.user?.name }}</h6>
                <small class="text-muted">{{ selectedAttempt.student?.user?.email }}</small>
              </div>
              <div class="row mb-4">
                <div class="col-md-3">
                  <small class="text-muted">Score</small>
                  <p class="fw-bold">{{ selectedAttempt.obtained_marks }}/{{ quiz?.total_marks }}</p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Percentage</small>
                  <p class="fw-bold">{{ ((selectedAttempt.obtained_marks / quiz?.total_marks) * 100).toFixed(2) }}%</p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Status</small>
                  <p>
                    <span v-if="(selectedAttempt.obtained_marks / quiz?.total_marks * 100) >= quiz?.passing_percentage" class="badge bg-success">Passed</span>
                    <span v-else class="badge bg-danger">Failed</span>
                  </p>
                </div>
                <div class="col-md-3">
                  <small class="text-muted">Submitted</small>
                  <p>{{ formatDate(selectedAttempt.end_time) }}</p>
                </div>
              </div>

              <hr />

              <h6 class="mb-3">Student's Answers</h6>
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
                  <small><strong>Answer given:</strong></small><br />
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
import { useRoute } from 'vue-router'
import { teacherService } from '../../services/authService'

const route = useRoute()
const attempts = ref([])
const quiz = ref(null)
const isLoading = ref(false)
const selectedAttempt = ref(null)

onMounted(async () => {
  await fetchResults()
})

const fetchResults = async () => {
  isLoading.value = true
  try {
    // Get quiz details
    const quizResponse = await teacherService.getQuiz(route.params.id)
    quiz.value = quizResponse.data.quiz
    
    // Get results
    const resultsResponse = await teacherService.getResults(route.params.id)
    attempts.value = resultsResponse.data.attempts
  } catch (error) {
    console.error('Failed to fetch results:', error)
  } finally {
    isLoading.value = false
  }
}

const sortedAttemptAnswers = computed(() => {
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

const viewResults = async (attemptId) => {
  try {
    const response = await teacherService.getAttemptDetails(attemptId)
    selectedAttempt.value = response.data.attempt
  } catch (error) {
    console.error('Failed to fetch attempt details:', error)
    alert('Failed to load attempt details')
  }
}

const retakeAttempt = async (attemptId) => {
  if (!confirm('Really reset this attempt so student can retake?')) return

  isLoading.value = true
  try {
    await teacherService.resetAttempt(attemptId)
    alert('Attempt reset successfully. Student may retake.')
    await fetchResults()
    selectedAttempt.value = null
  } catch (error) {
    console.error('Failed to reset attempt:', error)
    alert('Failed to reset attempt')
  } finally {
    isLoading.value = false
  }
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString()
}
</script>
