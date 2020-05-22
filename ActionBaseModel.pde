class ActionBaseModel {
    final float MAXIMUM_SEGMENT_ANGLE = 1.2;
    final float SEGMENT_CIRCLE_RADIUS = 0.15;

    ArrayList<ActionModelClient> clients = new ArrayList<ActionModelClient>();
    ActionModelParent parentModel;

    float degradation = 0;
    boolean isDegradated = false;

    int indexInActionArray;
    float segmentSizeInActionCircle;
    float segmentAngleInActionCircle;
    PVector position = new PVector();


    ActionBaseModel(ActionModelParent parentModel) {
        this.parentModel = parentModel;
        parentModel.addAction(this);

        updatePosition();
    }
    

    void registerClient(ActionModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ActionModelClient client) {
        clients.remove(client);
    }


    ArrayList<ActionBaseModel> getParentActionList() {
        return parentModel.getActionList();
    }


    void updatePosition() {
        ArrayList<ActionBaseModel> actionArray = getParentActionList();

        segmentSizeInActionCircle = min(TWO_PI / actionArray.size(), MAXIMUM_SEGMENT_ANGLE);
        indexInActionArray = actionArray.indexOf(this);

        segmentAngleInActionCircle = indexInActionArray * segmentSizeInActionCircle;

        position.x = parentModel.getPosition().x + 0.5 + sin(segmentAngleInActionCircle) * SEGMENT_CIRCLE_RADIUS;
        position.y = parentModel.getPosition().y + 0.5 + -cos(segmentAngleInActionCircle) * SEGMENT_CIRCLE_RADIUS;
    }


    void tick() {
        degradation += random(0.001);
        if (degradation >= 1) {
            degradation = 1;
            isDegradated = true;
        }
    }
}
