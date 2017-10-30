using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class SceneController : MonoBehaviour {
    
    public Color GlowFirstColor;
    public Color GlowSecondColor;

    private GlassShatterEffect _GlassEffect;
    private Animator _SceneAnimator;
    private UnityEngine.PostProcessing.VignetteModel.Settings _VignetteSetting;


    // Use this for initialization
    void Start () {
        _GlassEffect = GetComponent<GlassShatterEffect>();
        _GlassEffect.EffectMaterial.SetFloat("_GlassThreshold", 0);
        _GlassEffect.EffectMaterial.SetFloat("_GlowThreshold", 0);
        Invoke("AnimateShatterGlass", 1f);
    }

    void AnimateShatterGlass()
    {
        _GlassEffect.EffectMaterial.DOFloat(1, "_GlassThreshold", 0.5f).OnComplete(StartGlow);
    }

    void StartGlow()
    {
        StartCoroutine(RepeatGlow());
    }

    IEnumerator RepeatGlow()
    {
        _GlassEffect.EffectMaterial.SetColor("_GlowColor", GlowFirstColor);
        yield return new WaitForSeconds(0.2f);
        do
        {
            _GlassEffect.EffectMaterial.DOFloat(1, "_GlowThreshold", 1f).OnComplete(()=> _GlassEffect.EffectMaterial.SetFloat("_GlowThreshold", 0));
            yield return new WaitForSeconds(4f);
            _GlassEffect.EffectMaterial.SetColor("_GlowColor", GlowSecondColor);
        } while (true);
    }
}
