import apiClient from './api'

export const authService = {
  register(data) {
    return apiClient.post('/auth/register', data)
  },
  
  login(email, password) {
    return apiClient.post('/auth/login', { email, password })
  },
  
  logout() {
    return apiClient.post('/auth/logout')
  },
  
  getProfile() {
    return apiClient.get('/auth/profile')
  },
  
  updateProfile(data) {
    return apiClient.put('/auth/profile', data)
  }
}

export const teacherService = {
  getQuizzes() {
    return apiClient.get('/teacher/quizzes')
  },
  
  createQuiz(data) {
    return apiClient.post('/teacher/quizzes', data)
  },
  
  getQuiz(id) {
    return apiClient.get(`/teacher/quizzes/${id}`)
  },
  
  updateQuiz(id, data) {
    return apiClient.put(`/teacher/quizzes/${id}`, data)
  },
  
  deleteQuiz(id) {
    return apiClient.delete(`/teacher/quizzes/${id}`)
  },
  
  getResults(quizId) {
    return apiClient.get(`/teacher/quizzes/${quizId}/results`)
  },
  
  getAttemptDetails(attemptId) {
    return apiClient.get(`/teacher/attempts/${attemptId}`)
  },
  
  resetAttempt(attemptId) {
    return apiClient.post(`/teacher/attempts/${attemptId}/reset`)
  },
  
  getStudentResults(studentId) {
    return apiClient.get(`/teacher/students/${studentId}/results`)
  },
  
  addQuestion(quizId, data) {
    return apiClient.post(`/teacher/quizzes/${quizId}/questions`, data)
  },
  
  addOption(questionId, data) {
    return apiClient.post(`/teacher/questions/${questionId}/options`, data)
  },
  
  deleteQuestion(questionId) {
    return apiClient.delete(`/teacher/questions/${questionId}`)
  },
  
  updateQuestion(questionId, data) {
    return apiClient.put(`/teacher/questions/${questionId}`, data)
  }
}

export const studentService = {
  getAvailableQuizzes() {
    return apiClient.get('/student/quizzes')
  },
  
  getQuiz(quizId) {
    return apiClient.get(`/student/quizzes/${quizId}`)
  },
  
  startQuiz(quizId) {
    return apiClient.post(`/student/quizzes/${quizId}/start`)
  },
  
  submitAnswer(data) {
    return apiClient.post('/student/answer', data)
  },
  
  submitQuiz(attemptId) {
    return apiClient.post(`/student/attempts/${attemptId}/submit`)
  },
  
  getResults() {
    return apiClient.get('/student/results')
  },
  
  getAttemptDetails(attemptId) {
    return apiClient.get(`/student/attempts/${attemptId}`)
  }
}
