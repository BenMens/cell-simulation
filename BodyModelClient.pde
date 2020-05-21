interface BodyModelClient {
    void onAddCell(CellModel cellModel);

    void onAddParticle(ParticleBaseModel particleModel);

    void onRemoveCell(CellModel cellModel);

    void onRemoveParticle(ParticleBaseModel particleModel);
}
