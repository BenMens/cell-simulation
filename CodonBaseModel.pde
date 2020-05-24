class CodonBaseModel {
    final float MAXIMUM_SEGMENT_ANGLE = 1.2;
    final float SEGMENT_CIRCLE_RADIUS = 0.15;

    ArrayList<CodonModelClient> clients = new ArrayList<CodonModelClient>();
    CodonModelParent parentModel;

    float degradation = 0;
    boolean isDegradated = false;

    int indexInCodonArray;
    float segmentSizeInCodonCircle;
    float segmentAngleInCodonCircle;
    private PVector position = new PVector();


    CodonBaseModel(CodonModelParent parentModel) {
        this.parentModel = parentModel;
        parentModel.addCodon(this);

        updatePosition();
    }
    

    void registerClient(CodonModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CodonModelClient client) {
        clients.remove(client);
    }


    ArrayList<CodonBaseModel> getParentCodonList() {
        return parentModel.getCodonList();
    }


    void updatePosition() {
        ArrayList<CodonBaseModel> codonArray = getParentCodonList();

        segmentSizeInCodonCircle = min(TWO_PI / codonArray.size(), MAXIMUM_SEGMENT_ANGLE);
        indexInCodonArray = codonArray.indexOf(this);

        segmentAngleInCodonCircle = indexInCodonArray * segmentSizeInCodonCircle;

        position.x = parentModel.getPosition().x + 0.5 + sin(segmentAngleInCodonCircle) * SEGMENT_CIRCLE_RADIUS;
        position.y = parentModel.getPosition().y + 0.5 + -cos(segmentAngleInCodonCircle) * SEGMENT_CIRCLE_RADIUS;
    }

    PVector getPosition() {
        return position;
    }


    void tick() {
        degradation += random(0.001);
        if (degradation >= 1) {
            degradation = 1;
            isDegradated = true;
        }
    }
}
