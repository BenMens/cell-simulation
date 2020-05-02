interface ViewFactory {
    CellView createView(CellModel cellModel);

    BodyView createView(BodyModel bodyModel);

    ParticleView createView(ParticleBaseModel particleModel);
}
