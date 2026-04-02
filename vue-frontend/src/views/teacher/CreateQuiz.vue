<template>
  <div class="container my-5" style="max-width: 700px;">

    <!-- Header -->
    <div class="mb-4 text-center">
      <h2 class="fw-bold">Create Quiz</h2>
      <p class="text-muted mb-0">Fill in the details to create a new quiz</p>
    </div>

    <!-- Card -->
    <div class="card shadow-sm">
      <div class="card-body p-4">

        <form @submit.prevent="createQuiz">

          <!-- Title -->
          <div class="mb-3">
            <label class="form-label fw-semibold">Title</label>
            <input v-model="form.title" class="form-control" required />
          </div>

          <!-- Description -->
          <div class="mb-3">
            <label class="form-label fw-semibold">Description</label>
            <textarea v-model="form.description" class="form-control" rows="3"></textarea>
          </div>

          <!-- Row -->
          <div class="row">

            <!-- Duration -->
            <div class="col-md-6 mb-3">
              <label class="form-label fw-semibold">Duration (minutes)</label>
              <input v-model.number="form.duration" type="number" class="form-control" min="1" required />
            </div>

            <!-- Total Marks -->
            <div class="col-md-6 mb-3">
              <label class="form-label fw-semibold">Total Marks</label>
              <input v-model.number="form.total_marks" type="number" class="form-control" min="1" required />
            </div>

          </div>

          <!-- Passing -->
          <div class="mb-4">
            <label class="form-label fw-semibold">Passing Percentage</label>
            <input
              v-model.number="form.passing_percentage"
              type="number"
              min="0"
              max="100"
              class="form-control"
              required
            />
          </div>

          <!-- Button -->
          <div class="d-grid">
            <button class="btn btn-primary">
              Create Quiz
            </button>
          </div>

        </form>

      </div>
    </div>

  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { teacherService } from '../../services/authService'

const router = useRouter()

const form = reactive({
  title: '',
  description: '',
  duration: 60,
  total_marks: 100,
  passing_percentage: 40
})

const createQuiz = async () => {
  try {
    const res = await teacherService.createQuiz(form)
    router.push(`/teacher/quizzes/${res.data.quiz.id}`)
  } catch (error) {
    console.error(error.response?.data || error)
  }
}
</script>