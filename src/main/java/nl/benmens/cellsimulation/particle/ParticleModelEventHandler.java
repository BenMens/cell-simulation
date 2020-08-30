package nl.benmens.cellsimulation.particle;

interface ParticleModelEventHandler {

  default public void onDestroy(ParticleBaseModel particleModel) {};

}
