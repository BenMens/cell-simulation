class CellEditorView extends ViewBase {
    CellModel cellModel;

    ArrayList<CellEditorViewClient> clients = new ArrayList<CellEditorViewClient>();

    PFont font;

    final float CODONS_Y_POS = 380f;
    final float CODONS_SPACING = 5f;

    CellEditorView(ViewBase parentView, CellModel cellModel) {
        super(parentView);

        this.cellModel = cellModel;

        this.shouldClip = true;

        font = createFont("courrier.dfont", 24);
    }

    void beforeLayoutChildren() {
        setBoundsRect(0, 0, getFrameRect().width, getFrameRect().height);
    }


    void registerClient(CellEditorViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }  
    }


    void unregisterClient(CellEditorViewClient client) {
        clients.remove(client);
    }


    float calcCodonsHeight() {
        
        float verticalSpace = getFrameRect().height - CODONS_Y_POS - 40;
        float codonHeight = (verticalSpace + CODONS_SPACING) / cellModel.codonModels.size() - CODONS_SPACING;
        codonHeight = min(codonHeight , 60);

        return codonHeight;
    }


    void beforeDrawChildren() {
        background(10, 10, 10);
        
        Rectangle2D.Float boundsRect = getBoundsRect();

        fill(255);
        textFont(font);
        textAlign(LEFT, TOP);

        text(String.format("Food #: NA"), 250, 20);
        text(String.format("Waste #: NA"), 250, 50);


        text(String.format("Oxygen: NA"), 20, 234);
        text(String.format("Food: NA"), 20, 264);
        text(String.format("Energy: %.1f",this.cellModel.energyLevel * 100), 20, 294);
        text(String.format("WallHealth: %.1f",this.cellModel.wallHealth * 100), 20, 324);

        float codonHeight = calcCodonsHeight();

        float progressToNextCodonTick = norm(cellModel.ticksSinceLastCodonTick, 0, cellModel.ticksPerCodonTick);

        float currentCodonPos = cellModel.currentCodon * (codonHeight + CODONS_SPACING) + codonHeight * .5;
        float nextCodonPos = ((cellModel.currentCodon + 1) % cellModel.codonModels.size()) * (codonHeight + CODONS_SPACING) + codonHeight * .5;

        float codonHandYPos = smoothLerp(currentCodonPos, nextCodonPos, 0.1, 0.8, progressToNextCodonTick) + CODONS_Y_POS;

        noStroke();

        fill(200, 200, 200);
        rect(20, CODONS_Y_POS - 20, boundsRect.width - 40, boundsRect.height - CODONS_Y_POS) ;

        fill(245, 245, 115);

        beginShape();
        vertex(  25, codonHandYPos - 15);
        vertex(  40, codonHandYPos);
        vertex(  25, codonHandYPos + 15);
        endShape(CLOSE);

        beginShape();
        vertex( boundsRect.width - 25, codonHandYPos - 15);
        vertex( boundsRect.width - 40, codonHandYPos);
        vertex( boundsRect.width - 25, codonHandYPos + 15);
        endShape(CLOSE);
    }


    float smoothLerp(float start, float end, float startLerping, float stopLerping, float fraction) {
        float lerpFraction = 1;

        if (fraction < startLerping) {
            lerpFraction = 0;
        } else if (fraction < stopLerping) {
            lerpFraction = 1 / (1 + exp(-map(fraction, startLerping, stopLerping, -6, 6)));
        }

        return lerp(start, end, lerpFraction);
    }


}
