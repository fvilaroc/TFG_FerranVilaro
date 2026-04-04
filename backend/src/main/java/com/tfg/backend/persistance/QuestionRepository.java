package com.tfg.backend.persistance;

import com.tfg.backend.domain.Difficulty;
import com.tfg.backend.domain.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface QuestionRepository extends JpaRepository<Question, Long> {

    List<Question> findByDanceName(String danceName);

    List<Question> findByDanceIdAndDifficulty(Long danceId, Difficulty difficulty);

    Optional<Question> findByQuestionId(Long questionId);
}
