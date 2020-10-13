using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostRenderEffectManager : MonoBehaviour
{
	#region Editor-Exposed Propert(ies)
	public Material PostRenderEffectMaterial;
	#endregion



	#region MonoBehavior Method(s)
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (PostRenderEffectMaterial != null)
		{
			//If a post-render effect has been set, apply its shader to the rendered frame.
			Graphics.Blit(source, destination, PostRenderEffectMaterial);
		}
		else
		{
			Graphics.Blit(source, destination);
		}
	}
	#endregion
}
