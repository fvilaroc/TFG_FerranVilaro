package com.tfg.backend.controller;

import com.tfg.backend.domain.Question;
import com.tfg.backend.domain.User;
import com.tfg.backend.service.QuestionService;
import com.tfg.backend.service.UserDanceProgressService;
import com.tfg.backend.service.UserService;
import com.tfg.backend.service.dto.AnswerRequestDTO;
import com.tfg.backend.service.dto.AnswerResponseDTO;
import com.tfg.backend.service.dto.QuestionDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {

    private final QuestionService questionService;
    private final UserService userService;
    private final UserDanceProgressService userDanceProgressService;

    public QuestionController(QuestionService questionService, UserService userService, UserDanceProgressService userDanceProgressService) {
        this.questionService = questionService;
        this.userService = userService;
        this.userDanceProgressService = userDanceProgressService;
    }

    @GetMapping("/quiz/{danceId}")
    @PreAuthorize("hasAnyAuthority('SCOPE_PREMIUM', 'SCOPE_ADMIN')")
    public List<QuestionDTO> generateQuiz(Authentication authentication,
                                          @PathVariable Long danceId) {

        User user = userService.getUserEntityByUsername(authentication.getName());

        return questionService.generateQuiz(user.getId(), danceId);
    }

    @PostMapping("/check")
    @PreAuthorize("hasAnyAuthority('SCOPE_PREMIUM', 'SCOPE_ADMIN')")
    public AnswerResponseDTO checkAnswer(Authentication authentication,
                                         @RequestBody AnswerRequestDTO request) {

        User user = userService.getUserEntityByUsername(authentication.getName());

        int points = questionService.checkAnswer(
                request.getQuestionId(),
                request.getAnswer()
        );

        if (points > 0) {
            // sumar puntos al progreso
            Long danceId = questionService.getDanceIdByQuestionId(request.getQuestionId());

            userDanceProgressService.addPointsToUserDance(
                    user.getId(),
                    danceId,
                    points
            );
        }

        return new AnswerResponseDTO(points > 0, points);
    }

    @PostMapping("/save")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public Question saveQuestion(@RequestBody Question question) {
        return questionService.saveQuestion(question);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public void deleteQuestion(@PathVariable Long id) {
        questionService.deleteQuestion(id);
    }
}
