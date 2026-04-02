<template>
  <div class="container my-4" style="max-width: 1100px;">

    <!-- Header -->
    <div class="row mb-4 align-items-center">
      <div class="col-md-6">
        <h2 class="fw-bold mb-0">My Quizzes</h2>
      </div>
      <div class="col-md-6 text-md-end mt-3 mt-md-0">
        <router-link to="/teacher/quizzes/create" class="btn btn-primary">
          + Create Quiz
        </router-link>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border"></div>
    </div>

    <!-- Empty -->
    <div v-else-if="quizzes.length === 0" class="alert alert-info text-center">
      No quizzes yet. Create your first quiz!
    </div>

    <!-- Table -->
    <div v-else class="table-responsive">
      <table class="table table-bordered table-hover align-middle text-center">

        <!-- Header -->
        <thead class="table-primary">
          <tr>
            <th class="text-start">Title</th>
            <th>Duration</th>
            <th>Status</th>
            <th>Questions</th>
            <th>Attempts</th>
            <th>Actions</th>
          </tr>
        </thead>

        <!-- Body -->
        <tbody>
          <tr v-for="quiz in quizzes" :key="quiz.id">

            <!-- Title -->
            <td class="text-start fw-semibold">
              {{ quiz.title }}
            </td>

            <!-- Duration -->
            <td>
              {{ quiz.duration }} mins
            </td>

            <!-- Status -->
            <td>
              <span v-if="quiz.is_published" class="badge bg-success px-3 py-2">
                Published
              </span>
              <span v-else class="badge bg-warning text-dark px-3 py-2">
                Draft
              </span>
            </td>

            <!-- Questions -->
            <td>
              {{ quiz.questions?.length || 0 }}
            </td>

            <!-- Attempts -->
            <td>
              {{ quiz.attempts?.length || 0 }}
            </td>

            <!-- Actions -->
            <td>
              <div class="d-flex justify-content-center flex-wrap gap-2">

                <router-link
                  :to="`/teacher/quizzes/${quiz.id}`"
                  class="btn btn-sm btn-outline-primary"
                >
                  Edit
                </router-link>

                <router-link
                  :to="`/teacher/quizzes/${quiz.id}/results`"
                  class="btn btn-sm btn-outline-success"
                >
                  Results
                </router-link>

                <button
                  class="btn btn-sm btn-outline-danger"
                  @click="deleteQuiz(quiz.id)"
                  :disabled="quiz.attempts?.length > 0"
                >
                  Delete
                </button>

              </div>
            </td>

          </tr>
        </tbody>

      </table>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { teacherService } from '../../services/authService'

const quizzes = ref([])
const isLoading = ref(false)

onMounted(() => {
  fetchQuizzes()
})

const fetchQuizzes = async () => {
  isLoading.value = true
  try {
    const res = await teacherService.getQuizzes()
    quizzes.value = res.data.quizzes
  } catch (err) {
    console.error('Failed to fetch quizzes:', err)
  } finally {
    isLoading.value = false
  }
}

const deleteQuiz = async (quizId) => {
  if (!confirm('Are you sure you want to delete this quiz?')) return

  try {
    await teacherService.deleteQuiz(quizId)
    await fetchQuizzes()
    alert('Quiz deleted successfully')
  } catch (err) {
    console.error(err)
    alert(
      err.response?.status === 409
        ? 'Cannot delete quiz with attempts'
        : 'Failed to delete quiz'
    )
  }
}
</script>