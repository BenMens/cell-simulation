package nl.benmens.cellsimulation.particle;

interface ParticleModelClient {

  default public void onDestroy(ParticleBaseModel particleModel) {};

}
