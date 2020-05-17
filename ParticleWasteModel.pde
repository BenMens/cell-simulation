class ParticleWasteModel extends ParticleBaseModel {

    ParticleWasteModel(BodyModel bodyModel) {
        super(bodyModel);
    }
    ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY) {
        super(bodyModel, positionX, positionY);
    }
    ParticleWasteModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
        super(bodyModel, positionX, positionY, speedX, speedY);
    }
    
}