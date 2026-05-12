// ─── INJEÇÃO DE DEPENDÊNCIA ───────────────────────────────────────────────────
// Para integrar com o backend, basta trocar as implementações aqui.
// A UI nunca precisa ser alterada.
//
// Exemplo de troca:
//   AppServices.ai = ApiAiAnalysisService(baseUrl: 'https://api.senacdevnest.com');
//   AppServices.matching = ApiMatchingService(baseUrl: 'https://api.senacdevnest.com');

import 'ai_analysis_service.dart';
import 'matching_service.dart';

class AppServices {
  AppServices._();

  // ── IA de Análise de Projetos
  // Trocar por: ApiAiAnalysisService(baseUrl: Env.apiUrl)
  static AiAnalysisService ai = MockAiAnalysisService();

  // ── Matching Aluno ↔ Empresa
  // Trocar por: ApiMatchingService(baseUrl: Env.apiUrl)
  static MatchingService matching = MockMatchingService();
}
