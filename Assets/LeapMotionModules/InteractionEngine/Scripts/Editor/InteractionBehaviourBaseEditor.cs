﻿using UnityEngine;
using UnityEditor;

namespace Leap.Unity.Interaction {

  [CanEditMultipleObjects]
  [CustomEditor(typeof(InteractionBehaviourBase), true)]
  public class InteractionBehaviourBaseEditor : CustomEditorBase {
    protected InteractionBehaviourBase _interactionBehaviour;
    protected InteractionManager _manager;

    protected override void OnEnable() {
      base.OnEnable();

      if (targets.Length == 1) {
        _interactionBehaviour = target as InteractionBehaviourBase;
        _manager = _interactionBehaviour.GetComponentInParent<InteractionManager>();
        if (_manager == null) {
          _manager = FindObjectOfType<InteractionManager>();
        }
      } else {
        _interactionBehaviour = null;
      }

      if (PrefabUtility.GetPrefabType((target as Component).gameObject) != PrefabType.Prefab) {
        specifyCustomDecorator("_manager", managerDectorator);
      }
    }

    private void managerDectorator(SerializedProperty prop) {
      if (_interactionBehaviour == null) {
        return;
      }

      Rigidbody rigidbody = _interactionBehaviour.GetComponent<Rigidbody>();

      if (rigidbody == null) {
        using (new GUILayout.HorizontalScope()) {
          EditorGUILayout.HelpBox("This component requires a Rigidbody", MessageType.Error);
          if (GUILayout.Button("Auto-Fix")) {
            rigidbody = _interactionBehaviour.gameObject.AddComponent<Rigidbody>();
            rigidbody.interpolation = RigidbodyInterpolation.Interpolate;
            rigidbody.useGravity = true;
            rigidbody.isKinematic = false;
          }
        }
      } else {
        if (rigidbody.isKinematic) {
          if (rigidbody.useGravity) {
            EditorGUILayout.HelpBox("Rigidbody is set as Kinematic but has gravity enabled.", MessageType.Warning);
          } else {
            EditorGUILayout.HelpBox("Will be simulated as Kinematic.", MessageType.Info);
          }
        } else {
          if (rigidbody.useGravity) {
            EditorGUILayout.HelpBox("Will be simulated with gravity.", MessageType.Info);
          } else {
            EditorGUILayout.HelpBox("Will be simulated without gravity.", MessageType.Info);
          }
        }

        if (rigidbody.interpolation != RigidbodyInterpolation.Interpolate) {
          using (new GUILayout.HorizontalScope()) {
            EditorGUILayout.HelpBox("It is recommended to use interpolation on Rigidbodies to improve interaction fidelity.", MessageType.Warning);
            if (GUILayout.Button("Auto-Fix")) {
              rigidbody.interpolation = RigidbodyInterpolation.Interpolate;
              EditorUtility.SetDirty(rigidbody);
            }
          }
        }
      }

      if (prop.objectReferenceValue == null) {
        using (new EditorGUILayout.HorizontalScope()) {
          EditorGUILayout.HelpBox("Interaction Behaviour must be linked to an Interaction Manager", MessageType.Error);
          if (_manager != null) {
            if (GUILayout.Button("Auto-Fix")) {
              prop.objectReferenceValue = _manager;
            }
          }
        }
      }
    }

    public override void OnInspectorGUI() {
      base.OnInspectorGUI();

      if (Application.isPlaying && _interactionBehaviour != null) {
        EditorGUILayout.Space();

        if (!_interactionBehaviour.IsRegisteredWithManager) {
          EditorGUILayout.LabelField("Interaction Disabled", EditorStyles.boldLabel);
        } else {
          EditorGUILayout.LabelField("Interaction Info", EditorStyles.boldLabel);
          using (new EditorGUI.DisabledGroupScope(true)) {
            EditorGUILayout.IntField("Grasping Hand Count", _interactionBehaviour.GraspingHandCount);
            EditorGUILayout.IntField("Untracked Hand Count", _interactionBehaviour.UntrackedHandCount);
          }
        }
      }
    }
  }
}
