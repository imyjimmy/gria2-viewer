﻿using UnityEngine;
using System.Collections;
using System;

namespace Leap.Unity.Interaction {

  /**
  * The ThrowingControllerPalmVelocity class transfers the instantaneous palm velocity of the releasing hand to
  * the object.
  * @since 4.1.4
  */
  public class ThrowingControllerPalmVelocity : IThrowingController {

    /** 
     * Modifies the release velocity.
     *
     * Use this curve to modify the velocity transfered based on its canonical speed.
     * If the animation curve value is below 1.0 at a particular speed, then the transfered 
     * velocity is diminished; if the curve value is greater than one, the transfered 
     * velocity is amplified.
     * @since 4.1.4
     */
    [Tooltip("X axis is the speed of the released object.  Y axis is the value to multiply the speed by.")]
    [SerializeField]
    private AnimationCurve _velocityMultiplierCurve = new AnimationCurve(new Keyframe(0, 1, 0, 0),
                                                                    new Keyframe(3, 1.5f, 0, 0));

    /** Does nothing in this implementation. */
    public override void OnHold(ReadonlyList<Hand> hands) { }

    /** Applies the palm velocity, modified by the _throwingVelocityCurve, to the released object. */
    public override void OnThrow(Hand throwingHand) {
      Vector3 palmVel = throwingHand.PalmVelocity.ToVector3();
      float speed = palmVel.magnitude;
      float multiplier = _velocityMultiplierCurve.Evaluate(speed / _obj.Manager.SimulationScale);
      _obj.rigidbody.velocity = palmVel * multiplier;
    }
  }
}
