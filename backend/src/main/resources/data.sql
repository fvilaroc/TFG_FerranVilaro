-- =========================================================
-- DADES INICIALS DEL PROJECTE TFG
-- Contrasenya dels usuaris de prova: 123456
-- =========================================================

-- =========================
-- USUARIS DE PROVA
-- =========================

INSERT INTO user_tfg (
    email,
    username,
    password,
    dateOfBirth,
    registrationDate,
    points,
    lastLogin,
    streak,
    roles
)
SELECT
    'free@test.com',
    'pau',
    '$2y$10$M4T6byce4ymoPghowbxiyev6TMYO0PqmYMLYFDCksStpoRDlGbx6O',
    '2000-01-01',
    CURRENT_DATE,
    100,
    CURRENT_DATE,
    1,
    'FREE'
WHERE NOT EXISTS (
    SELECT 1 FROM user_tfg WHERE email = 'free@test.com'
);

INSERT INTO user_tfg (
    email,
    username,
    password,
    dateOfBirth,
    registrationDate,
    points,
    lastLogin,
    streak,
    roles
)
SELECT
    'premium@test.com',
    'paula',
    '$2y$10$M4T6byce4ymoPghowbxiyev6TMYO0PqmYMLYFDCksStpoRDlGbx6O',
    '2000-01-01',
    CURRENT_DATE,
    350,
    CURRENT_DATE,
    5,
    'PREMIUM'
WHERE NOT EXISTS (
    SELECT 1 FROM user_tfg WHERE email = 'premium@test.com'
);

INSERT INTO user_tfg (
    email,
    username,
    password,
    dateOfBirth,
    registrationDate,
    points,
    lastLogin,
    streak,
    roles
)
SELECT
    'admin@test.com',
    'ferran',
    '$2y$10$M4T6byce4ymoPghowbxiyev6TMYO0PqmYMLYFDCksStpoRDlGbx6O',
    '2000-01-01',
    CURRENT_DATE,
    150,
    CURRENT_DATE,
    5,
    'ADMIN'
WHERE NOT EXISTS (
    SELECT 1 FROM user_tfg WHERE email = 'admin@test.com'
);


-- =========================
-- BAILES
-- =========================

INSERT INTO dances (
    name,
    region,
    origin,
    description,
    history,
    clothing,
    musicCharacteristics,
    danceSteps,
    videoUrl
)
SELECT
    'Sevillanas',
    'Andalucía',
    'Las sevillanas proceden de las antiguas seguidillas, especialmente de la seguidilla manchega, que con el tiempo se fue adaptando al carácter festivo andaluz y se aflamencó progresivamente. Actualmente se consideran una de las danzas populares más representativas de Andalucía.',
    'Las sevillanas son un baile tradicional andaluz de carácter alegre y festivo. Normalmente se bailan en pareja y son muy habituales en ferias, romerías y celebraciones populares. Se estructuran en cuatro partes o coplas, conocidas como las cuatro sevillanas.',
    'Su evolución está relacionada con la transformación de las seguidillas populares en una forma musical y coreográfica propia de Andalucía. Con el paso del tiempo, las sevillanas se incorporaron a fiestas tradicionales como la Feria de Abril y el Rocío, convirtiéndose en un símbolo cultural andaluz.',
    'En las mujeres es habitual el traje de flamenca o traje de gitana, con volantes, colores vivos y complementos como flores, pendientes y mantoncillo. En los hombres puede utilizarse el traje corto andaluz, especialmente en contextos festivos o ferias.',
    'La música de las sevillanas suele tener compás de 3/4 y se acompaña habitualmente con guitarra, palmas y, en algunos casos, castañuelas, tamboril o flauta rociera. Su carácter es rítmico, alegre y pensado para acompañar el baile.',
    'El baile se organiza en cuatro sevillanas. Cada una incluye movimientos como paseíllos, pasadas, careos y remates. Los bailarines se desplazan de forma coordinada, alternando cruces, giros, movimientos de brazos y marcajes con los pies, terminando cada parte con una posición final o desplante.',
    'https://www.youtube.com/watch?v=g8TEe911CEY'
WHERE NOT EXISTS (
    SELECT 1 FROM dances WHERE name = 'Sevillanas'
);

INSERT INTO dances (
    name,
    region,
    description,
    videoUrl
)
SELECT
    'Muñeira',
    'Galicia',
    'La muñeira es un baile tradicional gallego que se caracteriza por su ritmo alegre y enérgico. Es una danza popular que se suele bailar en pareja o en grupo, y es muy común en festividades y celebraciones en Galicia. La muñeira tiene un compás de 6/8 y se acompaña con música tradicional gallega, especialmente con la gaita, el tamboril y la pandereta.',
    'https://www.youtube.com/watch?v=example2'
WHERE NOT EXISTS (
    SELECT 1 FROM dances WHERE name = 'Muñeira'
);

INSERT INTO dances (
    name,
    region,
    description,
    videoUrl
)
SELECT
    'Jota',
    'Aragón',
    'La jota aragonesa es un baile tradicional muy conocido por su ritmo vivo y los movimientos enérgicos. Forma parte del patrimonio cultural de Aragón y se acompaña habitualmente con cantos e instrumentos tradicionales.',
    'https://www.youtube.com/watch?v=example3'
WHERE NOT EXISTS (
    SELECT 1 FROM dances WHERE name = 'Jota'
);


-- =========================
-- PREGUNTES DE TEST
-- =========================

INSERT INTO question_lab (
    question,
    correctAnswer,
    optionA,
    optionB,
    optionC,
    optionD,
    points,
    difficulty,
    dance_id
)
SELECT
    '¿De que comunidad autónoma son típicas las sevillanas?',
    'Andalucía',
    'Galicia',
    'Andalucía',
    'Cataluña',
    'Aragón',
    10,
    'EASY',
    d.id
FROM dances d
WHERE d.name = 'Sevillanas'
AND NOT EXISTS (
    SELECT 1 FROM question_lab
    WHERE question = '¿De que comunidad autónoma son típicas las sevillanas?'
);

INSERT INTO question_lab (
    question,
    correctAnswer,
    optionA,
    optionB,
    optionC,
    optionD,
    points,
    difficulty,
    dance_id
)
SELECT
    '¿Qué instrumento es muy característico en la música tradicional gallega?',
    'Gaita',
    'Guitarra elèctrica',
    'Gaita',
    'Piano',
    'Saxòfon',
    10,
    'EASY',
    d.id
FROM dances d
WHERE d.name = 'Muñeira'
AND NOT EXISTS (
    SELECT 1 FROM question_lab
    WHERE question = '¿Qué instrumento es muy característico en la música tradicional gallega?'
);

INSERT INTO question_lab (
    question,
    correctAnswer,
    optionA,
    optionB,
    optionC,
    optionD,
    points,
    difficulty,
    dance_id
)
SELECT
    '¿De que comunidad autónoma es especialmente representativa la jota aragonesa?',
    'Aragón',
    'Andalucía',
    'País Vasco',
    'Aragón',
    'Galicia',
    10,
    'EASY',
    d.id
FROM dances d
WHERE d.name = 'Jota'
AND NOT EXISTS (
    SELECT 1 FROM question_lab
    WHERE question = '¿De que comunidad autónoma es especialmente representativa la jota aragonesa?'
);


-- =========================
-- PROGRÉS PER BALL
-- =========================

INSERT INTO user_dance_progress (
    user_id,
    dance_id,
    points
)
SELECT
    u.id,
    d.id,
    100
FROM user_tfg u, dances d
WHERE u.email = 'premium@test.com'
AND d.name = 'Sevillanas'
AND NOT EXISTS (
    SELECT 1
    FROM user_dance_progress udp
    WHERE udp.user_id = u.id
    AND udp.dance_id = d.id
);

INSERT INTO user_dance_progress (
    user_id,
    dance_id,
    points
)
SELECT
    u.id,
    d.id,
    80
FROM user_tfg u, dances d
WHERE u.email = 'premium@test.com'
AND d.name = 'Muñeira'
AND NOT EXISTS (
    SELECT 1
    FROM user_dance_progress udp
    WHERE udp.user_id = u.id
    AND udp.dance_id = d.id
);

INSERT INTO user_dance_progress (
    user_id,
    dance_id,
    points
)
SELECT
    u.id,
    d.id,
    200
FROM user_tfg u, dances d
WHERE u.email = 'admin@test.com'
AND d.name = 'Jota'
AND NOT EXISTS (
    SELECT 1
    FROM user_dance_progress udp
    WHERE udp.user_id = u.id
    AND udp.dance_id = d.id
);

-- =========================
-- MEDALLES D'USUARI
-- =========================

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'FIRST_LOGIN'
FROM user_tfg u
WHERE u.email = 'free@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'FIRST_LOGIN'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'FIRST_LOGIN'
FROM user_tfg u
WHERE u.email = 'premium@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'FIRST_LOGIN'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'STREAK_5'
FROM user_tfg u
WHERE u.email = 'premium@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'STREAK_5'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'PREMIUM_USER'
FROM user_tfg u
WHERE u.email = 'premium@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'PREMIUM_USER'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'FIRST_LOGIN'
FROM user_tfg u
WHERE u.email = 'admin@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'FIRST_LOGIN'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'STREAK_10'
FROM user_tfg u
WHERE u.email = 'admin@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'STREAK_10'
);

INSERT INTO user_medal (
    user_id,
    medal
)
SELECT
    u.id,
    'PREMIUM_USER'
FROM user_tfg u
WHERE u.email = 'admin@test.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_medal um
    WHERE um.user_id = u.id
    AND um.medal = 'PREMIUM_USER'
);