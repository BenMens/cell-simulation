class DefaultViewFactory implements ViewFactory {
    CellView createView(CellModel cellModel) {
        return new CellView(cellModel);
    }

    BodyView createView(BodyModel bodyModel) {
        return new BodyView(bodyModel);
    }

    ParticleView createView(ParticleBaseModel particleModel) {
        return new ParticleView(particleModel);
    }

}
