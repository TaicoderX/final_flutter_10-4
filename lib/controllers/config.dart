// String IP = "52.221.210.100";
String IP = "192.168.10.33";

String baseUrl = "http://$IP:3001/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String updateUsername = users + "/profiles/";
String uploadAvatarUrl = users + "/profiles/change-profile-image/";
String changePasswordUrl = users + "/profiles/password/";
String createAchievementUrl = users + "/achievement/";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";
String getTopicByIdUrl = topic + "/";
String getFolderByTopicIdUrl = topic + "/:id/folder";
String getTopicByFolderId = topic + "/folders/";
String getPublicTopicUrl = topic + "/public/getPublicTopic";
String createTopicUrl = topic;
String getTopicByUser = topic + "/get-topic-user";
String deleteTopicUrl = topic + "/";
String updateTopicUrl = topic + "/";
String updateVocabInTopicUrl = topic + "/:id/vocabularies/:vocabularyId";
String createVocabToTopicUrl = topic + "/:id/vocabularies";
String deleteVocabInTopicUrl = topic + "/:id/vocabularies/:vocabularyId";

// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";

//folder
String folder = baseUrl + "/folders";
String getFolderByFolderIdUrl = folder + "/";
String getFolderByUser = folder + "/users/";
String createFolderUrl = folder + "/";
String addTopicToFolderUrl = folder + "/:id/topics/:topicId";
String editFolderUrl = folder + "/";
String deleteFolderUrl = folder + "/";
String deleteTopicInFolderUrl = folder + "/:id/topics/:topicId";

// bookmark Vocab
String bookmarkVocab = baseUrl + "/bookmarkVocabularies";

String createBookmarkVocabUrl = bookmarkVocab;
String getAllBookmarkVocabByUser = bookmarkVocab;
String getBookmarkByTopic = bookmarkVocab + "/topics/";
String getBookmarkVocabByTopic = bookmarkVocab + "/topics/:topicId/vocabs";
String deleteBookmarkVocabUrl = bookmarkVocab + "/vocabularies/";

// learning statistic
String learningStatistic = baseUrl + "/learningStatistics";
String getStatisticByTopicIdUrl = learningStatistic + "/topic/";
String updateLearningStatisticUrl = learningStatistic + "/topic/:topicId/progress";

// get process learning
String getProcessLearning = learningStatistic + "/topic/:topicId/progress";
// update learning statistic
String updateProcessLearning = learningStatistic + "/topic/:topicId/progress";
// get learning statistics of users in a topic
String learningOfUserInTopic = learningStatistic + "/topic/:topicId";
// get user learning statistics for topic
String learningStatisticForUser = learningStatistic + "/topic/:topicId/user/:userId";

// achievement
String achievement = baseUrl + "/achievements";
String getAllAchie = achievement;
String createAchievement = achievement;

// vocabularyStatistics
String vocabularyStatistics = baseUrl + "/vocabularyStatistics";
String create_updateVocabStatisticUrl = vocabularyStatistics;
String getVocabularyStatisticByTopicIdUrl = vocabularyStatistics + "/topics/";
