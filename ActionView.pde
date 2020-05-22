class ActionView extends ViewBase {
    final float SEGMENT_SPACING_PERCENTAGE = 0.2;
    final float SEGMENT_CIRCLE_INNER_RADIUS = 10;
    final float SEGMENT_CIRCLE_OUTER_RADIUS = 20;

    ArrayList<ActionViewClient> clients = new ArrayList<ActionViewClient>();
    ActionBaseModel actionModel;

    color firstColor = color(random(255), random(255), random(255));
    color secondColor = color(random(255), random(255), random(255));


    ActionView(ActionBaseModel actionModel) {
        this.actionModel = actionModel;

        // todo #21
        // code below doesn't work jet because the clip is not fully implemented jet
        // this.size = new PVector(SEGMENT_CIRCLE_OUTER_RADIUS * 2, SEGMENT_CIRCLE_OUTER_RADIUS * 2);
        // this.position = new PVector(50 - SEGMENT_CIRCLE_OUTER_RADIUS, 50 - SEGMENT_CIRCLE_OUTER_RADIUS);
        // this.origin = new PVector(SEGMENT_CIRCLE_OUTER_RADIUS, SEGMENT_CIRCLE_OUTER_RADIUS);
        // this.hasClip = true;

        // this is a temporary fix
        this.position.x = 50 + actionModel.position.x % 1;
        this.position.y = 50 + actionModel.position.y % 1;
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
        if (actionModel.isDegradated) {
            firstColor = color(0);
            secondColor = color(0);
        }

        float screenSize = composedScale() * 100;
        makeChildsInvisible();

        if (screenSize > 75) {
            float secondVertexAngle = actionModel.segmentAngleInActionCircle;
            float firstVertexAngle = secondVertexAngle + (0.5 * SEGMENT_SPACING_PERCENTAGE - 0.5) * actionModel.segmentSizeInActionCircle;
            float thirdVertexAngle = secondVertexAngle + (0.5 - 0.5 * SEGMENT_SPACING_PERCENTAGE) * actionModel.segmentSizeInActionCircle;

            float segmentCircleBetweenRadius = lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_OUTER_RADIUS, 0.5);
            float segmentCircleInnerDegradationRadius = lerp(SEGMENT_CIRCLE_INNER_RADIUS, segmentCircleBetweenRadius, actionModel.degradation);
            float segmentCircleOuterDegradationRadius = lerp(SEGMENT_CIRCLE_OUTER_RADIUS, segmentCircleBetweenRadius, actionModel.degradation);
            
            float sinFirstVertexAngle = sin(firstVertexAngle);
            float sinSecondVertexAngle = sin(secondVertexAngle);
            float sinThirdVertexAngle = sin(thirdVertexAngle);
            float cosFirstVertexAngle = cos(firstVertexAngle);
            float cosSecondVertexAngle = cos(secondVertexAngle);
            float cosThirdVertexAngle = cos(thirdVertexAngle);

            noStroke();
            fill(color(0));
            beginShape();
            vertex(sinSecondVertexAngle * SEGMENT_CIRCLE_INNER_RADIUS, -cosSecondVertexAngle * SEGMENT_CIRCLE_INNER_RADIUS);
            vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
            vertex(sinSecondVertexAngle * SEGMENT_CIRCLE_OUTER_RADIUS, -cosSecondVertexAngle * SEGMENT_CIRCLE_OUTER_RADIUS);
            vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
            endShape(CLOSE);

            if (firstColor != color(0)) {
                fill(firstColor);
                beginShape();
                vertex(sinSecondVertexAngle * segmentCircleInnerDegradationRadius, -cosSecondVertexAngle * segmentCircleInnerDegradationRadius);
                vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
                vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
                endShape(CLOSE);
            }

            if (secondColor != color(0)) {
                fill(secondColor);
                beginShape();
                vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
                vertex(sinSecondVertexAngle * segmentCircleOuterDegradationRadius, -cosSecondVertexAngle * segmentCircleOuterDegradationRadius);
                vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
                endShape(CLOSE);
            }

        } else if (screenSize > 35) {
            float segmentCircleRadius = SEGMENT_CIRCLE_OUTER_RADIUS - SEGMENT_CIRCLE_INNER_RADIUS;

            pushMatrix();
            rotate(actionModel.segmentAngleInActionCircle + PI);

            stroke(lerpColor(firstColor, color(0), actionModel.degradation));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.25);

            stroke(lerpColor(secondColor, color(0), actionModel.degradation));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.75);
            popMatrix();
        }
    }
}
