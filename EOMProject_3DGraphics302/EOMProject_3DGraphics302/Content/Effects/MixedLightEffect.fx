#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix View;
matrix Projection;

//Point Light
float3 PointLightPositions[2];
float PointLightAttenuations[2] = {80,80};
float3 PointLightColors[2];
float PointLightFallOff = 2; //Inverse square law

//Directional Light
float3 DirectionalLightColor = float3(1, 1, 1);
float3 DirectionalLightDirection = float3(0, 1, 0);

//Common
float3 AmbientColor = float3(.15, .15, .15);
float3 DiffuseColor = float3(1, 1, 1);

Texture2D DiffuseTextureOne;
Texture2D DiffuseTextureTwo;
//Texture2D DiffuseTextureTwo;
Texture2D NormalTexture;
//sampler TextureSamples[3];

float3 CameraPosition;
float3 SpecularColor = float3(1, 1, 1);
float SpecularPower = 64;

//Samplers - Need to find a way to make into array
sampler DiffuseTextureSamplerOne 
= sampler_state
{
    texture = <DiffuseTexture>;
};

sampler DiffuseTextureSamplerTwo
= sampler_state
{
    texture = <DiffuseTextureTwo>;
};

sampler NormalTextureSampler
 = sampler_state
{
    texture = <NormalTexture>;
};

//Vertex Shader
struct VertexShaderInput
{
	float4 Position : POSITION0;
    float2 UV : TEXCOORD0;
    float3 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
    float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
    float3 ViewDirection : TEXCOORD3;
};


VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPos = mul(input.Position, World);
	float4 viewPos = mul(worldPos, View);

	output.Position = mul(viewPos, Projection);
	output.WorldPosition = worldPos;
	output.Normal = mul(input.Normal, World);
    output.ViewDirection = normalize(worldPos.xyz - CameraPosition);
	output.UV = input.UV;
   
	return output;
}

//Light Creation Methods
float4 CreatePointLight(VertexShaderOutput input, int arrayIndex):COLOR
{
    float3 color = DiffuseColor; //Color of the object
    color *= tex2D(DiffuseTextureSamplerOne, input.UV);
	
	float3 lightingColor = AmbientColor; //Color when no light
	float3 lightDirection = normalize(PointLightPositions[arrayIndex] - input.WorldPosition);
    
    float3 normal = tex2D(NormalTextureSampler, input.UV).rgb;
    normal = normal * 2 - 1;
	
	float3 intensity = saturate(dot(lightDirection, normal)) * PointLightColors[arrayIndex]; //No need for sampling normal?
	
    float3 reflection = reflect(lightDirection, normal);
    lightingColor += pow(saturate(dot(reflection, input.ViewDirection)), SpecularColor) * SpecularColor;
	
	float dis = distance(PointLightPositions[arrayIndex], input.WorldPosition);
	
	float attenuation = 1 - pow(clamp(dis / PointLightAttenuations[arrayIndex], 0, 1), PointLightFallOff);
    
	lightingColor += intensity;
    
    return float4(saturate(color * attenuation * lightingColor), 1);
}

float4 CreateDirectionalLight(VertexShaderOutput input):COLOR
{
    float3 color = DiffuseColor;
    color *= DiffuseTextureOne.Sample(DiffuseTextureSamplerOne, input.UV);
    
    float3 lightingColor = AmbientColor;
    float3 lightDirection = normalize(DirectionalLightDirection);
    
    float3 angle = saturate(dot(input.Normal, lightDirection));
    lightingColor += saturate(angle * color * DirectionalLightColor);
    
    return float4(lightingColor, 1);
   
}


//PixelShader
float4 MainPS(VertexShaderOutput input):COLOR
{
    float3 color = DiffuseColor; //Color of obj
    color *= tex2D(DiffuseTextureSamplerOne, input.UV);
    
    float3 lighting = AmbientColor; //Color when no light
    float3 lightDirection = normalize(PointLightPositions[0] - input.WorldPosition); //scales to 0-1 range
    
    //Oldway - per vertex lighting
    //float3 normal = normalize(input.Normal); //scales to 0-1 range
    
    //Normal Map Lighting [0,1] range
    float3 normal = tex2D(NormalTextureSampler, input.UV).rgb;
    
    //Shift to the [-1,1] range
    //normal = 1.0 * 2 -1;
    normal = normal * 2 - 1;
    
    
    float3 intensity = saturate(dot(lightDirection, normal)) * PointLightColors[0];
    
    float3 reflection = reflect(lightDirection, normal);
    lighting += pow(saturate(dot(reflection, input.ViewDirection)), SpecularPower) * SpecularColor;
    
    //angle between light and surface normal
    
    float dist = distance(PointLightPositions[0], input.WorldPosition);
    
    //Inverse square law -> how much light will the vertex recieve
    float att = 1 - pow(clamp(dist / PointLightAttenuations[0], 0, 1), PointLightFallOff);
    
    lighting += intensity;
    
    return float4(saturate(lighting * att * color), 1);
}


technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};