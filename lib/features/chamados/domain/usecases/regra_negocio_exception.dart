/// Exceção lançada quando uma regra de negócio é violada.
class RegraNegocioException implements Exception {
  final String mensagem;

  const RegraNegocioException(this.mensagem);

  @override
  String toString() => mensagem;
}
