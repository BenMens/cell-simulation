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

        //this.origin = new PVector(segmentCircleOuterRadius * 0.5, segmentCircleOuterRadius * 0.5);
        //this.position = new PVector(100 - segmentCircleOuterRadius, 100 - segmentCircleOuterRadius);
        
        //this.hasClip = true;
        this.size = new PVector(segmentCircleOuterRadius, segmentCircleOuterRadius);

        this.position = new PVector(50, 50);
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

        PVector screenSize = viewSizeToScreenSize(new PVector(100, 100));
        makeChildsInvisible();

        if(screenSize.x > 35 && screenSize.y > 35) {
            ArrayList<ActionBaseModel> actionArray = actionModel.getParentActionList();

            float segmentAngle = min(TWO_PI / actionArray.size(), maximumSegmentAngle);
            int indexInActionArray = actionArray.indexOf(actionModel);

            if(screenSize.x < 65 && screenSize.y < 65) {
                float rotation = indexInActionArray * segmentAngle;
                float segmentCircleRadius = segmentCircleOuterRadius - segmentCircleInnerRadius;

                pushMatrix();
                rotate(rotation + PI);

                stroke(lerpColor(firstColor, color(0), actionModel.degradation));
                strokeWeight(segmentCircleRadius * 0.5);
                point(0, segmentCircleInnerRadius + segmentCircleRadius * 0.25);

                stroke(lerpColor(secondColor, color(0), actionModel.degradation));
                strokeWeight(segmentCircleRadius * 0.5);
                point(0, segmentCircleInnerRadius + segmentCircleRadius * 0.75);
                popMatrix();

            } else {
                float firstVertexAngle = (indexInActionArray - 0.5 + 0.5 * segmentSpacingPercentage) * segmentAngle;
                float thirdVertexAngle = (indexInActionArray + 0.5 - 0.5 * segmentSpacingPercentage) * segmentAngle;
                float secondVertexAngle = lerp(firstVertexAngle, thirdVertexAngle, 0.5);

                float segmentCircleBetweenRadius = lerp(segmentCircleInnerRadius, segmentCircleOuterRadius, 0.5);
                float segmentCircleInnerDegradationRadius = lerp(segmentCircleInnerRadius, segmentCircleBetweenRadius, actionModel.degradation);
                float segmentCircleOuterDegradationRadius = lerp(segmentCircleOuterRadius, segmentCircleBetweenRadius, actionModel.degradation);
                
                float sinFirstVertexAngle = sin(firstVertexAngle);
                float sinSecondVertexAngle = sin(secondVertexAngle);
                float sinThirdVertexAngle = sin(thirdVertexAngle);
                float cosFirstVertexAngle = cos(firstVertexAngle);
                float cosSecondVertexAngle = cos(secondVertexAngle);
                float cosThirdVertexAngle = cos(thirdVertexAngle);

                noStroke();
                fill(color(0));
                beginShape();
                vertex(sinSecondVertexAngle * segmentCircleInnerRadius, -cosSecondVertexAngle * segmentCircleInnerRadius);
                vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
                vertex(sinSecondVertexAngle * segmentCircleOuterRadius, -cosSecondVertexAngle * segmentCircleOuterRadius);
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
            }
        }
    }
}
