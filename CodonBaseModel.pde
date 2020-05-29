abstract class CodonBaseModel {
    final float MAXIMUM_SEGMENT_ANGLE = 1.2;
    final float SEGMENT_CIRCLE_RADIUS = 0.15;

    ArrayList<CodonModelClient> clients = new ArrayList<CodonModelClient>();
    CodonModelParent parentModel;

    boolean isDead = false;

    int indexInCodonArray;
    float segmentSizeInCodonCircle;
    float segmentAngleInCodonCircle;
    protected PVector position = new PVector();

    ArrayList<String> possibleCodonParameters = new ArrayList<String>();
    protected String codonParameter = "none";

    float baseEnergyCost = 0.01;
    float degradation = 0;
    float degradationRate = 0.0002;

    protected color mainColor = color(0);
    protected HashMap<String, Integer> secondaryColors = new HashMap<String, Integer>();

    
    CodonBaseModel(CodonModelParent parentModel) {
        this.parentModel = parentModel;
        parentModel.addCodon(this);

        updatePosition();

        secondaryColors.put("none", color(0));
        secondaryColors.put("wall", color(250, 90, 70));
        secondaryColors.put("energy", color(245, 239, 50));
        secondaryColors.put("codons", color(45, 240, 190));
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


    void setCodonParameter(String parameter) {
        if (possibleCodonParameters.contains(parameter)) {
            codonParameter = parameter;
        }
    }


    color getMainColor() {
        return mainColor;
    }

    color getSecondaryColor() {
        return secondaryColors.get(codonParameter);
    }


    void tick() {
        degradation = min(degradation + random(degradationRate * 2), 1);

        if (degradation >= 1 && !(this instanceof CodonNoneModel)) {
            parentModel.replaceCodon(this, new CodonNoneModel(parentModel));
        }
    }


    void cleanUpTick() {
        if (isDead) {
            parentModel.removeCodon(this);

            for (CodonModelClient client: new ArrayList<CodonModelClient>(clients)) {
                client.onDestroy(this);
            }
        }
    }


    abstract float getEnergyCost();


    abstract void executeCodon();
}
