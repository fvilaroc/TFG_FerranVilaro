package com.tfg.backend.service;

import com.tfg.backend.domain.Difficulty;
import com.tfg.backend.domain.Question;
import com.tfg.backend.persistance.QuestionRepository;
import com.tfg.backend.service.dto.QuestionDTO;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class QuestionService {

    private final QuestionRepository questionRepository;
    private final UserDanceProgressService userDanceProgressService;

    public QuestionService(QuestionRepository questionRepository, UserDanceProgressService userDanceProgressService) {
        this.questionRepository = questionRepository;
        this.userDanceProgressService = userDanceProgressService;
    }

    public List<QuestionDTO> generateQuiz( Long userId, Long danceId) {

        Difficulty difficulty = userDanceProgressService.getDifficulty(userId, danceId);

        List<Question> questions = questionRepository.findByDanceIdAndDifficulty(danceId, difficulty);

        Collections.shuffle(questions);

        return questions.stream()
                .limit(10)
                .map(this::toDTO)
                .toList();
    }

    public int checkAnswer(Long questionId, String answer) {
        Question q = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        if(q.getCorrectAnswer().equalsIgnoreCase(answer)) {
            return q.getPoints();
        } else {
            return 0;
        }
    }

    public Long getDanceIdByQuestionId(Long questionId) {
        Question q = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        return q.getDance().getId();
    }

    public Question saveQuestion(Question question) {
        return questionRepository.save(question);
    }

    public void deleteQuestion(Long questionId) {
        if(!questionRepository.existsById(questionId)) {
            throw new RuntimeException("Question not found");
        }
        questionRepository.deleteById(questionId);
    }

    private QuestionDTO toDTO(Question question) {
        return new QuestionDTO(
                question.getId(),
                question.getQuestion(),
                question.getOptionA(),
                question.getOptionB(),
                question.getOptionC(),
                question.getOptionD(),
                question.getPoints(),
                question.getDifficulty(),
                question.getDance().getId()
        );
    }
}
