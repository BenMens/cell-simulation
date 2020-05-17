class ActionView extends ViewBase {
    ArrayList<ActionViewClient> clients = new ArrayList<ActionViewClient>();
    ActionBaseModel actionModel;

    final float maximumSegmentAngle = 1.2;
    final float segmentSpacingPercentage = 0.2;
    final float segmentCircleInnerRadius = 10;
    final float segmentCircleOuterRadius = 20;

    // color firstColor = color(200, 0, 100);
    // color secondColor = color(0, 200, 200);
    color firstColor = color(random(255), random(255), random(255));
    color secondColor = color(random(255), random(255), random(255));


    ActionView(ActionBaseModel actionModel) {
        this.actionModel = actionModel;

        position = new PVector(50, 50);
    }


    void registerClient(ActionViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ActionViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        ArrayList<ActionBaseModel> actionArray = actionModel.getParentActionList();

        float segmentAngle = min(TWO_PI / actionArray.size(), maximumSegmentAngle);
        int indexInActionArray = actionArray.indexOf(actionModel);

        float segmentCircleBetweenRadius = lerp(segmentCircleInnerRadius, segmentCircleOuterRadius, 0.5);
        float firstVertexAngle = (indexInActionArray + 0.5 * segmentSpacingPercentage) * segmentAngle;
        float secondVertexAngle = (indexInActionArray + 1 - 0.5 * segmentSpacingPercentage) * segmentAngle;

        noStroke();
        fill(lerpColor(firstColor, color(0), actionModel.degradation));
        beginShape();
        vertex(sin(firstVertexAngle) * segmentCircleInnerRadius, -cos(firstVertexAngle) * segmentCircleInnerRadius);
        vertex(sin(firstVertexAngle) * segmentCircleBetweenRadius, -cos(firstVertexAngle) * segmentCircleBetweenRadius);
        vertex(sin(secondVertexAngle) * segmentCircleBetweenRadius, -cos(secondVertexAngle) * segmentCircleBetweenRadius);
        vertex(sin(secondVertexAngle) * segmentCircleInnerRadius, -cos(secondVertexAngle) * segmentCircleInnerRadius);
        endShape(CLOSE);

        fill(lerpColor(secondColor, color(0), actionModel.degradation));
        beginShape();
        vertex(sin(firstVertexAngle) * segmentCircleBetweenRadius, -cos(firstVertexAngle) * segmentCircleBetweenRadius);
        vertex(sin(firstVertexAngle) * segmentCircleOuterRadius, -cos(firstVertexAngle) * segmentCircleOuterRadius);
        vertex(sin(secondVertexAngle) * segmentCircleOuterRadius, -cos(secondVertexAngle) * segmentCircleOuterRadius);
        vertex(sin(secondVertexAngle) * segmentCircleBetweenRadius, -cos(secondVertexAngle) * segmentCircleBetweenRadius);
        endShape(CLOSE);
    }
}
