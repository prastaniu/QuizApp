<template>
  <div class="container my-4" style="max-width: 1100px;">
    
    <!-- Header -->
    <div class="row mb-4">
      <div class="col-12">
        <h2 class="fw-bold">Edit Quiz</h2>
        <p class="text-muted mb-0">Manage your quiz questions and settings</p>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border"></div>
    </div>

    <!-- Quiz Content -->
    <div v-else-if="quiz">

      <!-- Quiz Details -->
      <div class="card mb-4 shadow-sm">
        <div class="card-header">
          <h5 class="mb-0">Quiz Details</h5>
        </div>
        <div class="card-body">
          <h4 class="fw-semibold">{{ quiz.title }}</h4>
          <p class="text-muted">{{ quiz.description }}</p>

          <div class="row mt-3 text-center text-md-start">
            <div class="col-md-4 mb-3">
              <div class="border rounded p-3 h-100">
                <small class="text-muted d-block">Duration</small>
                <strong>{{ quiz.duration }} mins</strong>
              </div>
            </div>

            <div class="col-md-4 mb-3">
              <div class="border rounded p-3 h-100">
                <small class="text-muted d-block">Total Marks</small>
                <strong>{{ quiz.total_marks }}</strong>
              </div>
            </div>

            <div class="col-md-4 mb-3 d-flex align-items-end">
              <button
                class="btn btn-success w-100"
                @click="publishQuiz"
                v-if="!quiz.is_published"
              >
                Publish Quiz
              </button>

              <button
                class="btn btn-warning w-100"
                v-else
                disabled
              >
                Published
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Questions -->
      <div class="card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Questions</h5>
          <button class="btn btn-sm btn-primary" @click="showAddQuestion = !showAddQuestion">
            + Add Question
          </button>
        </div>

        <div class="card-body">

          <!-- Add Question -->
          <div v-if="showAddQuestion" class="mb-4 p-4 border rounded bg-light shadow-sm">
            <h6 class="mb-3">Add New Question</h6>

            <form @submit.prevent="addQuestion">

              <div class="mb-3">
                <label class="form-label">Question</label>
                <textarea v-model="newQuestion.question_text" class="form-control" required></textarea>
              </div>

              <div class="row">
                <div class="col-md-6 mb-3">
                  <label class="form-label">Type</label>
                  <input v-model="newQuestion.question_type" class="form-control" readonly />
                </div>

                <div class="col-md-6 mb-3">
                  <label class="form-label">Marks</label>
                  <input v-model.number="newQuestion.marks" type="number" class="form-control" min="1" required />
                </div>
              </div>

              <!-- Options -->
              <div v-if="newQuestion.question_type === 'multiple_choice'" class="mb-3">
                <label class="form-label">Options</label>

                <div
                  v-for="(option, index) in newQuestion.options"
                  :key="index"
                  class="row align-items-center mb-2"
                >
                  <div class="col-8">
                    <input
                      v-model="option.option_text"
                      class="form-control"
                      placeholder="Option text"
                      required
                    />
                  </div>

                  <div class="col-2 text-center">
                    <input
                      type="radio"
                      name="correct"
                      v-model="newQuestion.correct_option"
                      :value="index"
                    />
                  </div>

                  <div class="col-2 text-end">
                    <button
                      type="button"
                      class="btn btn-outline-danger btn-sm"
                      @click="removeOption(index)"
                      v-if="newQuestion.options.length > 2"
                    >
                      ✕
                    </button>
                  </div>
                </div>

                <button type="button" class="btn btn-sm btn-outline-primary mt-2" @click="addOption">
                  + Add Option
                </button>
              </div>

              <div class="mt-3">
                <button class="btn btn-success me-2">Add Question</button>
                <button type="button" class="btn btn-secondary" @click="showAddQuestion = false">
                  Cancel
                </button>
              </div>

            </form>
          </div>

          <!-- No Questions -->
          <div v-if="quiz.questions?.length === 0" class="alert alert-info">
            No questions added yet.
          </div>

          <!-- Question List -->
          <div v-else>
            <div
              v-for="(question, index) in quiz.questions"
              :key="question.id"
              class="mb-3 p-3 border rounded shadow-sm"
            >
              <div class="row align-items-center">

                <div class="col-md-10">
                  <h6 class="mb-1">
                    Q{{ index + 1 }}. {{ question.question_text }}
                  </h6>

                  <small class="text-muted">
                    {{ question.question_type }} | {{ question.marks }} marks
                  </small>

                  <div v-if="question.question_type === 'multiple_choice'" class="mt-2">
                    <ul class="list-unstyled ms-2 mb-0">
                      <li v-for="option in question.options" :key="option.id">
                        <small :class="option.is_correct ? 'text-success fw-bold' : ''">
                          • {{ option.option_text }}
                          <span v-if="option.is_correct">(Correct)</span>
                        </small>
                      </li>
                    </ul>
                  </div>
                </div>

                <div class="col-md-2 text-end mt-2 mt-md-0">
                  <button
                    class="btn btn-sm btn-outline-danger w-100"
                    @click="deleteQuestion(question.id)"
                  >
                    Delete
                  </button>
                </div>

              </div>
            </div>
          </div>

        </div>
      </div>

    </div>

    <!-- Not Found -->
    <div v-else class="alert alert-danger">
      Quiz not found
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { useRoute } from 'vue-router'
import { teacherService } from '../../services/authService'

const route = useRoute()
const quiz = ref(null)
const isLoading = ref(false)
const showAddQuestion = ref(false)

const newQuestion = reactive({
  question_text: '',
  question_type: 'multiple_choice',
  marks: 1,
  options: [
    { option_text: '' },
    { option_text: '' }
  ],
  correct_option: 0
})

onMounted(() => {
  fetchQuiz()
})

const fetchQuiz = async () => {
  const id = route.params.id
  if (isNaN(id)) return

  isLoading.value = true
  try {
    const res = await teacherService.getQuiz(id)
    quiz.value = res.data.quiz
  } catch (err) {
    quiz.value = null
  } finally {
    isLoading.value = false
  }
}

const addQuestion = async () => {
  try {
    const res = await teacherService.addQuestion(quiz.value.id, {
      question_text: newQuestion.question_text,
      question_type: newQuestion.question_type,
      marks: newQuestion.marks
    })

    const q = res.data.question

    for (let i = 0; i < newQuestion.options.length; i++) {
      const opt = newQuestion.options[i]
      if (opt.option_text.trim()) {
        await teacherService.addOption(q.id, {
          option_text: opt.option_text,
          is_correct: i === newQuestion.correct_option
        })
      }
    }

    await fetchQuiz()
    resetNewQuestion()
    showAddQuestion.value = false
  } catch (err) {
    console.error(err)
  }
}

const addOption = () => {
  newQuestion.options.push({ option_text: '' })
}

const removeOption = (index) => {
  if (newQuestion.options.length > 2) {
    newQuestion.options.splice(index, 1)
  }
}

const resetNewQuestion = () => {
  Object.assign(newQuestion, {
    question_text: '',
    question_type: 'multiple_choice',
    marks: 1,
    options: [{ option_text: '' }, { option_text: '' }],
    correct_option: 0
  })
}

const deleteQuestion = async (id) => {
  if (confirm('Delete this question?')) {
    await teacherService.deleteQuestion(id)
    await fetchQuiz()
  }
}

const publishQuiz = async () => {
  quiz.value.is_published = true
  await teacherService.updateQuiz(quiz.value.id, { is_published: true })
}
</script>